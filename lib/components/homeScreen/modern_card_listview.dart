import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider_tutorial/models/recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider_tutorial/util/http_service.dart';
import '../../screens/public_profile_screen.dart';
import '../../screens/detail_recipe_screen.dart';
import '../../screens/recipe_by_category_screen.dart';
import '../../util/shared_preference.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

class ModernCardListview extends StatefulWidget {
  Recipe recipeItem;
  final String userId;
  ModernCardListview(this.recipeItem, this.userId, {Key? key})
      : super(key: key);

  @override
  State<ModernCardListview> createState() => _ModernCardListviewState();
}

class _ModernCardListviewState extends State<ModernCardListview> {
  bool isLiked = false;
  bool isLoading = false;
  late String stateCountLike = '';
  late var finalIngredients = [];
  String bullet = "\u2022 ";
  late bool isMyRecipie = false;
  @override
  void initState() {
    String joinedList = widget.recipeItem.ingredients.join(', ');
    finalIngredients = joinedList.split(',');
    stateCountLike = widget.recipeItem.likedByUserIdCount.length.toString();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    String localUserId = await GlobalSharedPreference.getUserID();
    if (mounted) {
      setState(() {
        isLiked = widget.recipeItem.likedByUserIdCount.contains(widget.userId);

        stateCountLike = widget.recipeItem.likedByUserIdCount.length.toString();
      });

      if (localUserId.contains(widget.recipeItem.userId)) {
        if (mounted) {
          setState(() {
            isMyRecipie = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.recipeItem.isApproved
        ? Stack(
            children: [
              GestureDetector(
                onDoubleTap: isMyRecipie ? null : updateLikes,
                child: Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      // Need To Make it Gradient
                      // colorFilter: ColorFilter.mode(
                      //     Colors.black.withOpacity(0.6), BlendMode.darken),
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          ('http://10.0.2.2:3000/${(widget.recipeItem.recipeImage).replaceAll(r'\', '/')}')),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 250,
                left: 20,
                child: GestureDetector(
                  onTap: (() => _goToRecipeByCategory(widget.recipeItem)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: HexColor(widget.recipeItem.categoryHexColor),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Text(widget.recipeItem.recipeCategoryname,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            color: HexColor(widget.recipeItem.categoryHexColor),
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                left: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (() =>
                            _gotoProfileScreen(widget.recipeItem.userId)),
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                ('http://10.0.2.2:3000/${(widget.recipeItem.recipeUserImagePath).replaceAll(r'\', '/')}'),
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color:
                                        const Color.fromARGB(255, 32, 22, 92),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Whoops!',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                            ),
                            radius: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.recipeItem.recipeUserName,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$bullet${widget.recipeItem.createdAt}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 160,
                left: 30,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: (() => _gotoDetailRecipeScreen(widget.recipeItem)),
                    child: Text(
                      widget.recipeItem.recipeName,
                      style: GoogleFonts.getFont(
                        widget.recipeItem.categoryGoogleFont.isEmpty
                            ? 'GFS Neohellenic'
                            : widget.recipeItem.categoryGoogleFont,
                        textStyle: TextStyle(
                            fontSize: 40,
                            color: HexColor(widget.recipeItem.categoryHexColor),
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ),
              isMyRecipie
                  ? Container()
                  : Positioned(
                      bottom: 130,
                      left: 250,
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_outline_sharp,
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                          Text(
                            '$stateCountLike likes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ).tr(),
                        ],
                      ),
                    ),
              Positioned(
                bottom: 120,
                left: 30,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 10, 10, 4),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: const Color.fromARGB(255, 173, 173, 173)
                            .withOpacity(0.2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.fastfood_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              finalIngredients.length.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.timelapse,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.recipeItem.recipeDuration.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.recipeItem.recipeDifficulty,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: 10,
              //   child: SizedBox(
              //     width: size.width,
              //     height: size.height * 0.5 /10,
              //     child: Container(
              //       padding: const EdgeInsets.fromLTRB(4, 10, 10, 4),
              //       decoration: BoxDecoration(
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(10)),
              //           color: const Color.fromARGB(255, 173, 173, 173)
              //               .withOpacity(0.1)),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children:  [
              //           const Text(
              //             'Following',
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 20,
              //                 color: Colors.white),
              //           ).tr(),
              //           Text(
              //             bullet,
              //             style:const TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 20,
              //                 color: Colors.white),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          )
        : Container();
  }

  _gotoProfileScreen(String userId) async {
    String localUserId = await GlobalSharedPreference.getUserID();

    if (userId.contains(localUserId)) {
      return;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PublicProfileScreen(userId, '')),
      );
    }
  }

  void _gotoDetailRecipeScreen(Recipe recipeItem) {
    String routeName = 'HomePage';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeItem, routeName),
      ),
    );
  }

  updateLikes() async {
    if (!isLiked) {
      isLiked = true;
      await _sendLikeToServer();
    } else {
      await _sendDisLikeToServer();
      isLiked = false;
    }
  }

  _sendLikeToServer() {
    setState(() {
      isLoading = true;
    });

    HttpService.likeRecipe(widget.recipeItem.recipeId, widget.userId, true)
        .then((value) async {
      setState(() {
        stateCountLike = value.likedByUserIdCount.length.toString();
      });
      return Future.value(value);
    }).whenComplete(() => setState(() {
              isLoading = false;
            }));
  }

  _sendDisLikeToServer() {
    setState(() {
      isLoading = true;
    });

    HttpService.dislikeRecipe(widget.recipeItem.recipeId, widget.userId)
        .then((value) {
      setState(() {
        stateCountLike = value.likedByUserIdCount.length.toString();
      });
      return Future.value(value);
    }).whenComplete(() => setState(() {
              isLoading = false;
            }));
  }

  _goToRecipeByCategory(Recipe recipeItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeByCategoryScreen(recipeItem),
      ),
    );
  }
}
