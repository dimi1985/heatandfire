import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../components/profile/profile_recipe_card.dart';
import '../models/recipe.dart';
import '../providers/info_provider.dart';
import '../util/http_service.dart';
import '../models/user.dart';
import '../util/shared_preference.dart';

class PublicProfileScreen extends StatefulWidget {
  final String userId;
  final String routeName;
  const PublicProfileScreen(
    this.userId,
    this.routeName, {
    Key? key,
  }) : super(key: key);

  @override
  State<PublicProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PublicProfileScreen> {
  final List<Recipe> _profileRecipes = [];
  late Future<Recipe> getRecipies;
  late Future<User> getUser;
  late Future<User> getPublicUser;
  late String buttonText = '';
  late String localUserId = '';
  bool followingHimFound = false;
  bool isFollowingMeFound = false;
  bool isMe = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    localUserId = await GlobalSharedPreference.getUserID();
  }

  @override
  void initState() {
    super.initState();
    getRecipies =
        HttpService.getPublicUserRecipes(widget.userId, _profileRecipes);

    getUser = HttpService.getUserById().then((value) {
      followingHimFound = value.following.contains(widget.userId);

      if (followingHimFound) {
        setState(() {
          buttonText = 'UnFollow';
        });
      } else {
        setState(() {
          buttonText = 'Follow';
        });
      }
      return Future.value(value);
    });

    getPublicUser =
        HttpService.getUserPublicProfile(widget.userId).then((value) {
      isFollowingMeFound = value.following.contains(localUserId);

      if (isFollowingMeFound) {
        setState(() {
          buttonText = 'Follow Back';
        });
      } else {
        setState(() {
          buttonText = 'Follow';
        });
      }
      return Future.value(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<User>(
      future: getPublicUser,
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4395F),
                      ),
                    ),
                  ),
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
                            //###################    Top Section Profile    ######################################
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          ('http://10.0.2.2:3000/${(snapshot.data?.userImage ?? '').replaceAll(r'\', '/')}'),
                                          scale: size.aspectRatio * 0.10),
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
                                widget.routeName.contains('SocialPanel')
                                    ? Container()
                                    : FutureBuilder<User>(
                                        future: getUser,
                                        builder: (context, friendSnapshot) {
                                          if (friendSnapshot.hasData) {
                                            return ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  followingHimFound
                                                      ? _unfollow(infoProvider)
                                                      : isFollowingMeFound
                                                          ? _follow(
                                                              infoProvider)
                                                          : _follow(
                                                              infoProvider);
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      buttonText,
                                                    ).tr(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return Container();
                                        }),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                          ),
                          //###################    Following Section Profile    ######################################
                          SizedBox(
                            height: size.height * 0.064,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  width: 110,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                _profileRecipes.length
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      const Text(
                                        "0",
                                        style: TextStyle(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      const Text(
                                        "0",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          //###################    Recipe Section Profile    ######################################
                          const Text(
                            "Recipes",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ).tr(),
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
          });
        }
        return const CircularProgressIndicator();
      },
    );
  }

  _follow(InfoProvider infoProvider) async {
    String myId = await GlobalSharedPreference.getUserID();
    setState(() {
      infoProvider.toggleIsLoading();
    });

    HttpService.sendUserFollow(myId, widget.userId).then((value) {
      setState(() {
        buttonText = 'Following User';
      });

      if (value.message.contains('Following User')) {
        setState(() {
          buttonText = 'Following User';
        });
      }
    });
  }

  _unfollow(InfoProvider infoProvider) async {
    String myId = await GlobalSharedPreference.getUserID();
    setState(() {
      infoProvider.toggleIsLoading();
    });

    HttpService.sendUserUnFollow(myId, widget.userId).then((value) {
      setState(() {
        buttonText = 'Unfollow Success';
      });

      if (value.message.contains('Unfollow Success')) {
        setState(() {
          buttonText = 'Unfollow Success';
        });
      }
    });
  }
}
