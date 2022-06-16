import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/models/recipe.dart';
import 'package:provider_tutorial/util/http_service.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../providers/info_provider.dart';
import '../../../screens/detail_recipe_screen.dart';

class AdminRecipesCard extends StatefulWidget {
  final Recipe recipe;
  final List<Recipe> recipies;
  final InfoProvider infoProvider;

  const AdminRecipesCard(this.recipe, this.recipies, this.infoProvider,
      {Key? key})
      : super(key: key);

  @override
  State<AdminRecipesCard> createState() => _AdminRecipesCardState();
}

class _AdminRecipesCardState extends State<AdminRecipesCard> {
  bool isLoading = false;
  bool isApproved = false;
  @override
  void initState() {
    widget.infoProvider.isLoading = false;
    isApproved = widget.recipe.isApproved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(
      builder: (context, infoProvider, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ListTile(
            key: UniqueKey(),
            leading: SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / 5,
                child: Image.network(
                    HttpService.baseUrl + widget.recipe.recipeImage)),
            title: GestureDetector(
              onTap: () => _gotoDetailRecipeScreen(widget.recipe),
              child: Row(
                children: [
                  Text(widget.recipe.recipeName),
                  const SizedBox(width: 10),
                  Text('(${widget.recipe.recipeUserName})').tr(),
                ],
              ),
            ),
            subtitle: Row(
              children: [
                const Text('Is Approved').tr(),
                const SizedBox(width: 5),
                Text('${widget.infoProvider.isApproved}').tr()
              ],
            ),
            trailing: !isApproved
                ? SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: !isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 30,
                                  color: Color.fromARGB(255, 196, 15, 123),
                                ),
                                onPressed: () {
                                  //Implemet no aprroval
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.check_outlined,
                                  size: 30,
                                  color: Color.fromARGB(255, 38, 229, 168),
                                ),
                                onPressed: () {
                                  _approveRecipe(widget.recipe.recipeId);
                                },
                              )
                            ],
                          )
                        : const Text('loading'),
                  )
                : Text(widget.recipe.isApproved ? 'already approved' : isApproved? 'ok': 'something went wrong'),
          ),
        );
      },
    );
  }

  void _gotoDetailRecipeScreen(Recipe recipeItem) {
    String routeName = 'AdminPage';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeItem, routeName),
      ),
    );
  }

  _approveRecipe(String recipeId) async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () async {
      await HttpService.approveRecipe(widget.recipe.recipeId, true)
          .then((value) {
        if (mounted) {
          setState(() {
            if (value.serverMessage.contains('Recipe Approved')) {
              isApproved = true;
            }
          });
        }
      });
    });
  }
}
