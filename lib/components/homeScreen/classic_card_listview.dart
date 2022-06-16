import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider_tutorial/models/recipe.dart';
import '../../screens/detail_recipe_screen.dart';
import '../../screens/public_profile_screen.dart';
import '../../util/http_service.dart';
import '../../util/shared_preference.dart';
import 'package:easy_localization/easy_localization.dart';

class ClassicCardListView extends StatefulWidget {
  final Recipe recipeItem;
  final String userId;

  const ClassicCardListView(this.recipeItem, this.userId, {Key? key})
      : super(key: key);

  @override
  State<ClassicCardListView> createState() => _ClassicCardListViewState();
}

class _ClassicCardListViewState extends State<ClassicCardListView> {
  bool isLiked = false;
  bool isLoading = false;
  late var finalIngredients = [];
  String bullet = "\u2022 ";
  late String stateCountLike = '';
  late bool isMyRecipie = false;
  @override
  void initState() {
    String joinedList = widget.recipeItem.ingredients.join(', ');
    finalIngredients = joinedList.split(',');
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
    return widget.recipeItem.isApproved
        ? SizedBox(
            height: 345,
            child: InkWell(
              onTap: () {},
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                elevation: 4.0,
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (() => _gotoDetailRecipeScreen(widget.recipeItem)),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          width: MediaQuery.of(context).size.width /0.5,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            child: Image.network(
                              'http://10.0.2.2:3000/${(widget.recipeItem.recipeImage).replaceAll(r'\', '/')}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //'http://10.0.2.2:3000/${(recipeItem.recipeUserImagePath).replaceAll(r'\', '/')}'
                          GestureDetector(
                            onTap: (() =>
                                _gotoProfileScreen(widget.recipeItem.userId)),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: Image.network(
                                        ('http://10.0.2.2:3000/${(widget.recipeItem.recipeUserImagePath).replaceAll(r'\', '/')}'),
                                        fit: BoxFit.cover,
                                        width: 25.0,
                                        height: 25.0,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: const Color.fromARGB(
                                                255, 32, 22, 92),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Whoops!',
                                              style: TextStyle(fontSize: 9),
                                            ).tr(),
                                          );
                                        },
                                      ),
                                    ),
                                    radius: 25,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.recipeItem.recipeUserName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '$bullet${widget.recipeItem.createdAt}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                  color: HexColor(
                                      widget.recipeItem.categoryHexColor),
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
                                    color: HexColor(
                                        widget.recipeItem.categoryHexColor),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Text(
                      widget.recipeItem.recipeName,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 7.0),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 12, right: 12, bottom: 25),
                      child: SizedBox(
                        width: 350,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.fastfood_outlined,
                                  color: Colors.grey,
                                ),
                                const Text(
                                  'Items',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ).tr(),
                                Text(
                                  finalIngredients.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.timelapse,
                                  color: Colors.grey,
                                ),
                                const Text(
                                  'Duration',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ).tr(),
                                Text(
                                  widget.recipeItem.recipeDuration.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.restaurant_menu,
                                  color: Colors.grey,
                                ),
                                const Text(
                                  'Difficulty:',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ).tr(),
                                Text(
                                  widget.recipeItem.recipeDifficulty,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ).tr(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          //_showBottomCommentSheet
                          onPressed: null,
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.grey,
                          ),
                          //'$stateCountComments ${widget.recipies[widget.index].comments.length.toString()} Comments',
                          label: const Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ).tr(),
                        ),
                        Row(
                          children: [
                            IconButton(
                              //updateLikes
                              onPressed: updateLikes,
                              icon: Icon(
                                Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                            ),
                            Text(
                              '$stateCountLike likes',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
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
        MaterialPageRoute(builder: (context) => PublicProfileScreen(userId,'')),
      );
    }
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

  void _gotoDetailRecipeScreen(Recipe recipeItem) {
    String routeName = 'HomePage';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeItem, routeName),
      ),
    );
  }
}
