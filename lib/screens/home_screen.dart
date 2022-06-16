// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/util/shared_preference.dart';
import '../components/homeScreen/classic_card_listview.dart';
import '../components/homeScreen/modern_card_listview.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../providers/info_provider.dart';
import '../util/http_service.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe>? _mainRecipies = [];
  late Future<Recipe>? _futureRecipe;
  final List<Category>? _categories = [];
  late Future<Category>? _futureCategory;
  late String scrollType = '';
  late String userId = '';

  @override
  void initState() {
     super.initState();
    _futureCategory = HttpService.getAllCategories(_categories!);

    _futureRecipe =
        HttpService.getRecipiesSortBy(_mainRecipies!).then((value) async {
      String initScrollType = await GlobalSharedPreference.getInitScrolltype();
      scrollType = await GlobalSharedPreference.getScrollType();
      userId = await GlobalSharedPreference.getUserID();
      if (scrollType.isEmpty) {
        setState(() {
          scrollType = initScrollType;
        });
      } else if (scrollType.isNotEmpty && scrollType.contains('classic')) {
        scrollType = await GlobalSharedPreference.getScrollType();
      }
      return Future.value(value);
    });

    _mainRecipies = _mainRecipies!.toSet().toList(); // <---- Solved Duplicates
 
   
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(builder: (context, infoProvider, child) {
      return Scaffold(
        body: FutureBuilder<Recipe>(
          future: HttpService.getRecipiesSortBy(_mainRecipies!),
          builder: (context, snapshot) {
            if (scrollType.isNotEmpty) {
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: const PageScrollPhysics(), // this for snapping
                    itemCount: _mainRecipies!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var recipeItem = _mainRecipies![index];
                    
                      return scrollType.contains('modern')
                          ? ModernCardListview(recipeItem, userId)
                          : ClassicCardListView(recipeItem, userId);
                    });
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    });
  }
}
