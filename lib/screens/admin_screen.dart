import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider_tutorial/models/user.dart';
import '../providers/info_provider.dart';
import 'admin_category_screen.dart';
import 'admin_recipe_screen.dart';
import 'admin_user_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  final AsyncSnapshot<User> snapshot;
  const AdminPanelScreen(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(builder: (context, infoProvider, child) {
      return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Admin Panel'),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                GestureDetector(
                    onTap: () => _gotToPanels('Users'),
                    child: const ListTile(title: Text('Users'))),
                GestureDetector(
                    onTap: () => _gotToPanels('Recipes'),
                    child: const ListTile(title: Text('Recipes'))),
                GestureDetector(
                    onTap: () => _gotToPanels('Categories'),
                    child: const ListTile(title: Text('Categories')))
              ],
            )),
      );
    });
  }

  // AdminPanelUsers(widget.snapshot),
  //           const AdminPanelRecipies(),
  //           const AdminPanelCategories(),

  _gotToPanels(String action) {
    switch (action) {
      case 'Users':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPanelUsers(widget.snapshot),
          ),
        );
        break;
      case 'Recipes':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminPanelRecipies(),
          ),
        );
        break;
      case 'Categories':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const AdminPanelCategories(),
          ),
        );
        break;
    }
  }
}
