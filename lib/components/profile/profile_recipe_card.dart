import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider_tutorial/models/recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../screens/detail_recipe_screen.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

class ProfileRecipeCard extends StatefulWidget {
  final Recipe recipeItem;
  const ProfileRecipeCard(this.recipeItem, {Key? key}) : super(key: key);

  @override
  State<ProfileRecipeCard> createState() => _ProfileRecipeCardState();
}

class _ProfileRecipeCardState extends State<ProfileRecipeCard> {
  @override
  void initState() {
    super.initState();
  }
  


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: UniqueKey(),
      body: GestureDetector(
        onTap: () {
          _gotoDetailRecipeScreen(widget.recipeItem);
        },
        child: Stack(children: [
          if (widget.recipeItem.isApproved)
            Container(
              height: size.height * 0.16,
              width: size.width * 0.50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      ('http://10.0.2.2:3000/${(widget.recipeItem.recipeImage).replaceAll(r'\', '/')}')),
                ),
              ),
            ),
          widget.recipeItem.isApproved
              ? Positioned(
                bottom: 20,
                left: 30,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      widget.recipeItem.recipeName,
                      style: GoogleFonts.getFont(
                       widget.recipeItem.categoryGoogleFont,
                        textStyle: TextStyle(
                            fontSize: 40,
                            color: HexColor(widget.recipeItem.categoryHexColor),
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                ))
              : Center(
                  child: const Text('Waiting to be approved').tr(),
                ),
        ]),
      ),
    );
  }

  void _gotoDetailRecipeScreen(Recipe recipeItem) {
    String routeName = 'Native';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeItem,routeName),
      ),
    );
  }
}
