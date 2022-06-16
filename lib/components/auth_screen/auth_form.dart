import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/models/user.dart';
import 'package:provider_tutorial/screens/home_navigation.dart';
import 'package:provider_tutorial/util/color_pallette.dart';
import 'package:provider_tutorial/util/shared_preference.dart';
import '../../providers/info_provider.dart';
import '../../util/http_service.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  File? image;
  late bool doNotShowAlertDialogAgain = false;

  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Consumer<InfoProvider>(
      builder: (context, authProvider, child) {
        return Center(
          child: AnimatedSize(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 1500),
            child: SizedBox(
              width: screenSize.height * 0.45,
              height: authProvider.isSwitched
                  ? screenSize.height * 0.75
                  : screenSize.height * 0.45,
              child: Form(
                key: _formKey,
                //Center Card
                child: Card(
                  color: Colors.blueGrey.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListView(
                    children: [
                      //#######################    Username EditText   ###################################################
                      if (authProvider.isSwitched)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: usernameController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                                color: Colors.blueGrey, fontSize: 18),
                            key: UniqueKey(),
                            cursorColor: Colors.pink,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                //On Default Border Color
                                borderSide: const BorderSide(
                                  color: Colors.purpleAccent,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                //On Focus Border Color
                                borderSide: const BorderSide(
                                  color: Colors.purple,
                                ),
                              ),
                              filled: true,
                              label: const Text('Username',
                                      style: TextStyle(
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 18))
                                  .tr(),
                              labelStyle: const TextStyle(color: Colors.grey),
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.purple),
                              fillColor: Colors.white70,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter a Valid Username'.tr();
                              } else if (value.length < 6) {
                                return 'Username must  be 6 characters and greater!'
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ),

                      //#######################     Email EditText    ###################################################
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                              color: Colors.blueGrey, fontSize: 18),
                          key: UniqueKey(),
                          cursorColor: Colors.pink,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              //On Default Border Color
                              borderSide: const BorderSide(
                                color: Colors.purpleAccent,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              //On Focus Border Color
                              borderSide: const BorderSide(
                                color: Colors.purple,
                              ),
                            ),
                            filled: true,
                            label: const Text('Email',
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontSize: 18))
                                .tr(),
                            labelStyle: const TextStyle(color: Colors.grey),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.purple),
                            fillColor: Colors.white70,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter your Email'.tr();
                            } else if (!value.contains('@')) {
                              return 'Please Enter a Valid Email'.tr();
                            }
                            return null;
                          },
                        ),
                      ),

                      //####################################    Password EditText     ################################################
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          key: UniqueKey(),
                          //This will obscure text dynamically,
                          obscureText: !authProvider.passwordVisible,
                          obscuringCharacter: '●',
                          style: const TextStyle(
                              color: Colors.blueGrey, fontSize: 18),
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.pink,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              //On Default Border Color
                              borderSide: const BorderSide(
                                color: Colors.purpleAccent,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              //On Focus Border Color
                              borderSide: const BorderSide(
                                color: Colors.purple,
                              ),
                            ),
                            filled: true,
                            label: const Text(
                              'Password',
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent, fontSize: 18),
                            ).tr(),
                            labelStyle: const TextStyle(color: Colors.grey),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.purple),
                            fillColor: Colors.white70,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  authProvider.passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.purple),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  authProvider.toggleViewPassword();
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter your Password'.tr();
                            } else if (value.length < 6) {
                              return 'Password must 6 characters and greater!'
                                  .tr();
                            }
                            return null;
                          },
                        ),
                      ),

                      //####################################   Button  Area    ################################################
                      Column(
                        children: [
                          //Add some space
                          SizedBox(
                            height: screenSize.height * 0.10 / 5,
                          ),

                          SizedBox(
                            height: screenSize.height * 0.60 / 10,
                            width: screenSize.width * 0.70,
                            child: Column(
                              children: [
                                authProvider.isLoading
                                    ? const CircularProgressIndicator()

                                    //###########   Button    #######################
                                    : ElevatedButton(
                                        child:
                                            Text(authProvider.buttonStringValue)
                                                .tr(),
                                        onPressed: authProvider.isLoading
                                            ? null
                                            : () {
                                                authProvider.isSwitched
                                                    ? _register(authProvider)
                                                    : _login(authProvider);
                                              },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorPallete.button),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          //Add some space
                          SizedBox(
                            height: screenSize.height * 0.10 / 5,
                          ),
                          //Row With Switch and Text
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: ColorPallete.textBottomAcountBG),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Text
                                  Text(
                                    authProvider.isSwitched
                                        ? 'Have an Account? Get Started Here'
                                        : 'You do not Have an Account? Get Started Here',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            ColorPallete.textBottomAcountHint),
                                  ).tr(),
                                  // Toggle Switch
                                  Switch(
                                    value: authProvider.isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        authProvider.isSwitched = value;

                                        value = !value;
                                      });
                                      if (authProvider.isSwitched) {
                                        authProvider.changeToRegistration();
                                      } else if (!authProvider.isSwitched) {
                                        authProvider.changeToLogin();
                                      }
                                    },
                                    activeTrackColor:
                                        ColorPallete.switchActiveTrackColor,
                                    activeColor: ColorPallete.switchactiveColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _register(InfoProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        authProvider.isLoading = true;
      });

      String createdAt =
          DateFormat("MMM, EEE, yyyy, kk:mm").format(DateTime.now());
      String userType = 'user';
      HttpService.registerUser(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        image?.path ?? '',
        userType,
        createdAt,
      ).then((value) async {
        await GlobalSharedPreference.setUserID(value.id);
        await GlobalSharedPreference.setUserEmail(emailController.text);
        setState(() {
          authProvider.isLoading = false;
        });

        if (authProvider.hasError) {
          setState(() {
            authProvider.isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('An error Occured.'),
              duration: Duration(seconds: 5)));
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value.message),
            duration: const Duration(seconds: 5)));
      });
    }
  }

  _login(InfoProvider authProvider) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        authProvider.toggleIsLoading();
      });
      HttpService.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      ).then((value) async {
        GlobalSharedPreference.setUserID(value.id);
        GlobalSharedPreference.setUserName(value.username);
        GlobalSharedPreference.setUserImage(value.userImage);

        GlobalSharedPreference.setInitScrolltype('modern');

        setState(() {
          authProvider.isLoading = false;
        });
        if (authProvider.hasError) {
          setState(() {
            authProvider.isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('An error Occured.'),
              duration: Duration(seconds: 5)));
        } else if (value.message.contains('No user found')) {
          setState(() {
            authProvider.isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No user found. Check your Credential'),
              duration: Duration(seconds: 5)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message),
              duration: const Duration(seconds: 5)));
          bool isShowAlertDialogAgainEnabled =
              await GlobalSharedPreference.getDoNotShowAlertDialogAgain();

          if (!isShowAlertDialogAgainEnabled) {
            _showOneTimeLoginAletDialog(value, authProvider);
          } else {
            _goToHome(value);
          }
        }
      });
    }
  }

  void _goToHome(User value) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeNavigation(userId: value.id)),
      (Route<dynamic> route) => false,
    );
  }

  _showOneTimeLoginAletDialog(User value, InfoProvider authProvider) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  const Text("Save Credentials").tr(),
                ],
              ),
              content: const Text(
                      "Want to save credentials to enable One Time Login?")
                  .tr(),
              actions: [
                TextButton(
                  child: const Text("NO"),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        GlobalSharedPreference.setOneTimeLogin(false);
                        GlobalSharedPreference.setDoNotShowAlertDialogAgain(true);
                        _goToHome(value);
                      });
                    }
                  },
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        GlobalSharedPreference.setOneTimeLogin(true);
                        _goToHome(value);
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
