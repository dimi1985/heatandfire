import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/util/http_service.dart';

import '../components/admin/recipes/admin_recipes_card.dart';
import '../models/recipe.dart';
import '../providers/info_provider.dart';

class AdminPanelRecipies extends StatefulWidget {
  const AdminPanelRecipies({Key? key}) : super(key: key);

  @override
  State<AdminPanelRecipies> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminPanelRecipies> {
  final List<Recipe> _adminRecipies = [];
  late Future<Recipe> _futureRecipe;

  @override
  void initState() {
    _futureRecipe = HttpService.getAllRecipies(_adminRecipies);
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(builder: (context, infoProvider, child) {
      return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
        future: _futureRecipe,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: _adminRecipies.length,
                itemBuilder: (context, index) {
                  var recipe = _adminRecipies[index];
                 
                  return AdminRecipesCard(recipe,_adminRecipies,infoProvider);
                });
          }

          return const Center(child: CircularProgressIndicator(),);
        },
      ),
      );
    });
  }

  _showBottoSheet(
      BuildContext context, Recipe recipe, InfoProvider infoProvider) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter bottomSheetState) {
            return Scaffold(
              backgroundColor: const Color(0xFFE9E9E9),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    snap: false,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        child: Image.network(
                            HttpService.baseUrl + recipe.recipeImage),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: Text(
                            recipe.recipeCategoryname,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                          subtitle: Text(
                            recipe.recipeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    recipe.recipeDifficulty,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${recipe.recipeDuration} min',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "INGREDIENTS",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  recipe.ingredients
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", ""),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "PREPARATION",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 32),
                          child: Text(
                            recipe.recipePreparation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  child: infoProvider.isLoading
                                      ? const CircularProgressIndicator()
                                      : !infoProvider.isUploaded
                                          ? const Text('Approve',
                                              style: TextStyle(
                                                  color: Colors.white))
                                          : const Icon(Icons.check),
                                  onPressed: infoProvider.isLoading
                                      ? null
                                      : () {
                                          // saveRecipeToServer(bottomSheetState);
                                        }),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  child: infoProvider.isLoading
                                      ? const CircularProgressIndicator()
                                      : !infoProvider.isUploaded
                                          ? const Text('Decline',
                                              style: TextStyle(
                                                  color: Colors.white))
                                          : const Icon(Icons.check),
                                  onPressed: infoProvider.isLoading
                                      ? null
                                      : () {
                                          // saveRecipeToServer(bottomSheetState);
                                        }),
                            ])
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
