import 'package:flutter/material.dart';
import 'package:provider_tutorial/screens/home_navigation.dart';
import 'package:easy_localization/easy_localization.dart';

class SuccesDeleteScreen extends StatefulWidget {

  const SuccesDeleteScreen( {Key? key}) : super(key: key);

  @override
  State<SuccesDeleteScreen> createState() => _SuccesAddEditScreenState();
}

class _SuccesAddEditScreenState extends State<SuccesDeleteScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // 5 seconds over, navigate to Page2.

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeNavigation(userId: '0')),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 240, 105, 121)),
        child: Center(
          child: Text('Deleted Succesfully!'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              )),
        ),
      ),
    );
  }
}
