import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/models/recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider_tutorial/providers/info_provider.dart';
import 'package:provider_tutorial/screens/success_delete_screen.dart';
import '../util/http_service.dart';
import '../util/shared_preference.dart';
import 'edit_recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipeItem;
  final String routeName;
  const RecipeDetailScreen(this.recipeItem, this.routeName, {Key? key})
      : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isLiked = false;
  late bool isMe = false;
  late bool shouldShowIcon = true;
  late var finalIngredients = [];
  String bullet = "\u2022 ";
  late String userId = '';
  late String localUserId = '';
  @override
  void initState() {
    String joinedList = widget.recipeItem.ingredients.join(', ');
    finalIngredients = joinedList.split(',');
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
   
    localUserId = await GlobalSharedPreference.getUserID();
    if (localUserId.contains(widget.recipeItem.userId)) {
      setState(() {
        isMe = true;
      });
    } else {
      isMe = false;
    }
    if (widget.routeName.contains('HomePage')) {
      setState(() {
        shouldShowIcon = false;
      });
    } else if (widget.routeName.contains('AdminPage')) {
      setState(() {
        shouldShowIcon = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(builder: (context, infoProvider, child) {
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: HexColor(widget.recipeItem.categoryHexColor),
              
                iconTheme: const IconThemeData(
                  color: Colors.white, //change your color here
                ),
                expandedHeight: MediaQuery.of(context).size.height / 3.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: SizedBox(
                    height: MediaQuery.of(context).size.height / 3.2,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'http://10.0.2.2:3000/${(widget.recipeItem.recipeImage).replaceAll(r'\', '/')}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.recipeItem.recipeName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                    if (!isMe)
                      RawMaterialButton(
                        onPressed: () {},
                        fillColor: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 17,
                          ),
                        ),
                      ),
                    if (isMe)
                      infoProvider.isLoading
                          ? const CircularProgressIndicator()
                          : !shouldShowIcon
                              ? Container()
                              : IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      infoProvider.toggleIsLoading();
                                    });
                                    HttpService.deleteRecipe(
                                            widget.recipeItem.recipeId,
                                            widget.recipeItem.userId,
                                            widget.recipeItem.categoryId,
                                            widget.recipeItem.recipeImage)
                                        .then((value) {
                                      setState(() {
                                        infoProvider.toggleIsLoading();
                                      });
                                      if (value.serverMessage
                                          .contains('Recipe Deleted')) {
                                        _gotoProfilePage();
                                      }
                                    });
                                  },
                                ),
                    if (isMe)
                      !shouldShowIcon
                          ? Container()
                          : IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _goToEditScreen(widget.recipeItem);
                              },
                            )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 5.0, top: 2.0),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 10.0),
                    const Text(
                      'Difficulty:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ).tr(),
                    const SizedBox(width: 5.0),
                    Text(
                      widget.recipeItem.recipeDifficulty,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 5.0, top: 2.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    const Text(
                      "Items",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ).tr(),
                    const SizedBox(width: 5.0),
                    Text(
                      finalIngredients.length.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 10,
                ).tr(),
              ),

              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  finalIngredients
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", ""),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Preparation",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ).tr(),
              ),

              const SizedBox(height: 10.0),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.recipeItem.recipePreparation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              //Coming soon
              // const Text(
              //   "Reviews",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w800,
              //   ),
              //   maxLines: 2,
              // ),
              const SizedBox(height: 20.0),

              // ListView.builder(
              //   shrinkWrap: true,
              //   primary: false,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: comments == null?0:comments.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     Map comment = comments[index];
              //     return ListTile(
              //         leading: CircleAvatar(
              //           radius: 25.0,
              //           backgroundImage: AssetImage(
              //             "${comment['img']}",
              //           ),
              //         ),

              //         title: Text("${comment['name']}"),
              //         subtitle: Column(
              //           children: <Widget>[
              //             Row(
              //               children: <Widget>[
              //                 SmoothStarRating(
              //                   starCount: 5,
              //                   color: Constants.ratingBG,
              //                   allowHalfRating: true,
              //                   rating: 5.0,
              //                   size: 12.0,
              //                 ),
              //                 SizedBox(width: 6.0),
              //                 Text(
              //                   "February 14, 2020",
              //                   style: TextStyle(
              //                     fontSize: 12,
              //                     fontWeight: FontWeight.w300,
              //                   ),
              //                 ),
              //               ],
              //             ),

              //             SizedBox(height: 7.0),
              //             Text(
              //               "${comment["comment"]}",
              //             ),
              //           ],
              //         ),
              //     );
              //   },
              // ),

              const SizedBox(height: 10.0),
            ],
          ),
        ),
      );
    });
  }

  _gotoProfilePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccesDeleteScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _goToEditScreen(Recipe recipeItem) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditRecipeScreen(recipeItem)),
    );
  }
}
