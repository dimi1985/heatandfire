import 'package:flutter/material.dart';
import 'package:provider_tutorial/screens/home_navigation.dart';
import 'package:easy_localization/easy_localization.dart';


class SuccesAddEditScreen extends StatefulWidget {
  final String action;
  const SuccesAddEditScreen(this.action, {Key? key}) : super(key: key);

  @override
  State<SuccesAddEditScreen> createState() => _SuccesAddEditScreenState();
}

class _SuccesAddEditScreenState extends State<SuccesAddEditScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // 5 seconds over, navigate to Page2.
     
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  const HomeNavigation(userId: '0')),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.greenAccent),
        child: Center(
          child: Text(
            widget.action == 'add'
                ? 'Added Succesfully!'.tr()
                : 'Updated Succesfully!'.tr(),
            textAlign: TextAlign.center,
            style: widget.action == 'add'
                ? const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  )
                : const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
          ),
        ),
      ),
    );
  }
}
