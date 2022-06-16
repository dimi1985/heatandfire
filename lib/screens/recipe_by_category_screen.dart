import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider_tutorial/models/category.dart';
import 'package:provider_tutorial/util/http_service.dart';

import '../components/homeScreen/classic_card_listview.dart';
import '../models/recipe.dart';
import '../util/shared_preference.dart';

class RecipeByCategoryScreen extends StatefulWidget {
  final Recipe recipeItem;
  const RecipeByCategoryScreen(this.recipeItem, {Key? key}) : super(key: key);

  @override
  State<RecipeByCategoryScreen> createState() => _RecipeByCategoryScreenState();
}

class _RecipeByCategoryScreenState extends State<RecipeByCategoryScreen> {
  final List<Category> _categories = [];
  late Future<Category> _futureCategory;
  final List<Recipe> _recipies = [];
  late Future<Recipe> _futureRecipe;
  late String userID = '';
  @override
  void initState() {
    _futureRecipe = HttpService.getRecipesByCategory(
        _recipies, widget.recipeItem.categoryId);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    String localUserId = await GlobalSharedPreference.getUserID();
    setState(() {
      userID = localUserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(widget.recipeItem.categoryHexColor),
        title:  Text(widget.recipeItem.recipeCategoryname)),
      body: FutureBuilder<Recipe>(
          future: _futureRecipe,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: _recipies.length,
                  itemBuilder: (context, index) {
                    return ClassicCardListView(widget.recipeItem, userID);
                  });
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
