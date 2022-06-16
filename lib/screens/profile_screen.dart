import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/screens/add_recipe_screen.dart';
import 'package:provider_tutorial/screens/settings_screen.dart';
import '../components/profile/profile_recipe_card.dart';
import '../models/recipe.dart';
import '../providers/info_provider.dart';
import '../util/http_service.dart';
import '../models/user.dart';
import '../util/shared_preference.dart';
import 'public_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> getUser;
  late Future<User> getOtherUser;
  final List<User> _users = [];
  final List<bool> _isFollowing = [];
  late String userId = '';
  final List<Recipe> _profileRecipes = [];
  late Future<Recipe> getRecipies;
  late String sendButtonText = '';
  late String localUserId = '';
  bool isFollowingFound = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    localUserId = await GlobalSharedPreference.getUserID();
  }

  @override
  void initState() {
    super.initState();

    getRecipies = HttpService.getUserRecipes(_profileRecipes);
    getUser = HttpService.getUserById();
    getOtherUser = HttpService.getAllUsers(_users).then((value) {
      isFollowingFound = value.following.contains(localUserId);

      if (isFollowingFound) {
         print('true');
        print(isFollowingFound);
      } else {
         print('false');
      }
      return Future.value(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<User>(
      future: getUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Consumer<InfoProvider>(
            builder: (context, infoProvider, child) {
              return Scaffold(
                //###################    Behind AppBar Container    ######################################
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ).tr(),
                  centerTitle: true,
                ),
                body: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: size.width,
                        height: size.height,
                        decoration:
                            const BoxDecoration(color: Color(0xFFE4395F)),
                      ),
                    ),

                    //###################    Top Section Profile    ######################################

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: size.height * 0.75,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 32,
                                bottom: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 28,
                                        backgroundImage: NetworkImage(
                                          ('http://10.0.2.2:3000/${(snapshot.data?.userImage ?? '').replaceAll(r'\', '/')}'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data?.username ?? '',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            snapshot.data?.userType ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _edit(snapshot);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE4395F),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 24,
                                      ),
                                      child: Center(
                                        child: const Text(
                                          'UserSettings',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ).tr(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),
                            //###################    Following Section Profile    ######################################
                            SizedBox(
                              height: size.height * 0.064,
                              child: FutureBuilder<User>(
                                  future: getOtherUser,
                                  builder: (context, userSnapshot) {
                                    if (userSnapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 110,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "RECIPES",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ).tr(),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                FutureBuilder<Recipe>(
                                                    future: getRecipies,
                                                    builder: (context,
                                                        recipeSnapshot) {
                                                      if (recipeSnapshot
                                                          .hasData) {
                                                        return Text(
                                                          _profileRecipes.length
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        );
                                                      }
                                                      return Container();
                                                    }),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 110,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "FOLLOWING",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ).tr(),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data!.following.length
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 110,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "FOLLOWER",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ).tr(),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  _isFollowing.length
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  }),
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            //###################    Recipe Section Profile    ######################################
                            Row(
                              children: [
                                Expanded(
                                  child: const Text(
                                    "Recipes",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ).tr(),
                                ),
                                Expanded(
                                  child: FutureBuilder<Recipe>(
                                      future: getRecipies,
                                      builder: (context, snapshot) {
                                        return GestureDetector(
                                          onTap: (() =>
                                              _gotoAddRecipeScreen(snapshot)),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 81, 65, 115),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 24,
                                            ),
                                            child: Center(
                                              child: const Text(
                                                'Add Recipe',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ).tr(),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              height: size.height * 0.28,
                              child: FutureBuilder<Recipe>(
                                  future: getRecipies,
                                  builder: (context, snapshot) {
                                    return GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              childAspectRatio: 3 / 2,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      padding: const EdgeInsets.all(8),
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: _profileRecipes.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var recipeItem = _profileRecipes[index];
                                        return _profileRecipes.isEmpty
                                            ? Container()
                                            : ProfileRecipeCard(recipeItem);
                                      },
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _edit(AsyncSnapshot<User> snapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen(snapshot)),
    );
  }

  _gotoAddRecipeScreen(AsyncSnapshot<Recipe> snapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipeScreen(snapshot)),
    );
  }

  _gotoProfileScreen(String userId, String routeName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PublicProfileScreen(userId, routeName)),
    );
  }
}
