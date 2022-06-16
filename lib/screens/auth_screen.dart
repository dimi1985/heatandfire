import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/util/color_pallette.dart';
import 'package:provider_tutorial/util/shared_preference.dart';
import '../components/auth_screen/auth_form.dart';
import '../providers/info_provider.dart';
import 'home_navigation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isOneTimeLogin = false;

  @override
  void initState() {
    super.initState();
    _getOneTimeLogin(isOneTimeLogin);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InfoProvider(),
      child: Scaffold(
        body: Container(
          //Auth Backround Color
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/bg_fire_four.gif'),
            ),
          ),
          child: const AuthForm(),
        ),
      ),
    );
  }

  void _getOneTimeLogin(bool isOneTimeLogin) async {
    String userId = await GlobalSharedPreference.getUserID();
    bool oneTimeLogin = await GlobalSharedPreference.getOneTimeLogin();

    if (oneTimeLogin) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('One Time Login Enabled'),
              duration: Duration(seconds: 3)));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeNavigation(userId: userId)),
        (Route<dynamic> route) => false,
      );
    } else {
      return;
    }
  }
}
