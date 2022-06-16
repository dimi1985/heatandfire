import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/screens/auth_screen.dart';
import 'package:provider_tutorial/util/http_service.dart';
import 'package:provider_tutorial/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider_tutorial/providers/info_provider.dart';
import 'package:provider_tutorial/screens/admin_screen.dart';
import '../util/color_pallette.dart';
import '../util/shared_preference.dart';

class SettingsScreen extends StatefulWidget {
  final AsyncSnapshot<User> snapshot;
  const SettingsScreen(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? imageFile;
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  late Future<User> _futureUser;
  late String scrollType = '';
  late bool showShowCredsAlert = false;

  @override
  void initState() {
    super.initState();
    _futureUser = HttpService.getUserById().then((value) async {
      scrollType = await GlobalSharedPreference.getScrollType();
      showShowCredsAlert =
          await GlobalSharedPreference.getDoNotShowAlertDialogAgain();
      return Future.value(value);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(
      builder: (context, infoProvider, child) {
        return FutureBuilder<User>(
            future: infoProvider.changesToServerMade ? _futureUser : null,
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ).tr(),
                  backgroundColor: Colors.white,
                  titleTextStyle: const TextStyle(color: Colors.black),
                  iconTheme: const IconThemeData(color: Colors.black),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        //###################    Image Profile    ######################################
                        GestureDetector(
                          onTap: (() =>
                              _pickImage(infoProvider, widget.snapshot)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  ColorPallete.emptyBackroundImageColor,
                              child: ClipOval(
                                child: infoProvider.isImagePicked &&
                                        infoProvider.changesToServerMade
                                    ? Image.file(File(imageFile?.path ?? ''))
                                    : Image.network(
                                        ('http://10.0.2.2:3000/${(widget.snapshot.data?.userImage ?? '').replaceAll(r'\', '/')}'),
                                        fit: BoxFit.cover,
                                        width: 60.0,
                                        height: 60.0,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: const Color.fromARGB(
                                                255, 32, 22, 92),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Whoops!',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              radius: 25,
                            ),
                            title: const Text('Change Picture').tr(),
                            subtitle:
                                const Text('Changing Profile Picture').tr(),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),
                        //###################    Username Profile    ######################################
                        GestureDetector(
                          onTap: (() => _changeUsername(infoProvider)),
                          child: ListTile(
                            leading: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.greenAccent,
                            ),
                            title: const Text('Change Username').tr(),
                            subtitle: Text('Changing your username'.tr() +
                                '(${(infoProvider.changesToServerMade ? snapshot.data?.username : widget.snapshot.data?.username ?? '')})'),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),
                        //###################    Email Profile    ######################################
                        GestureDetector(
                          onTap: (() => _changeEmail(infoProvider)),
                          child: ListTile(
                            leading: const Icon(
                              Icons.email,
                              size: 40,
                              color: Colors.blueGrey,
                            ),
                            title: const Text('Change Email').tr(),
                            subtitle: Text('Changing your email address'.tr() +
                                '(${(infoProvider.changesToServerMade ? snapshot.data?.email : widget.snapshot.data?.email ?? '')})'),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),
                        //###################    Password Profile    ######################################
                        ListTile(
                          leading: const Icon(
                            Icons.password,
                            size: 40,
                            color: Color.fromARGB(255, 244, 54, 82),
                          ),
                          title: const Text('Change Password').tr(),
                          subtitle: const Text(
                                  'Here you can change your password(3 Times)')
                              .tr(),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),
                        //###################    DarkTheme Profile    ######################################
                        ListTile(
                          leading: const Icon(
                            Icons.picture_in_picture,
                            size: 40,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          title: const Text('Change to DarkTheme').tr(),
                          subtitle: const Text(
                                  'Here you can change your app to a little darker theme')
                              .tr(),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),
                        //###################    Main Scroll Style Profile    ######################################
                        GestureDetector(
                          onTap: (() => _showAletDialog(context)),
                          child: ListTile(
                            leading: const Icon(
                              Icons.list_alt,
                              size: 40,
                              color: Color.fromARGB(255, 33, 58, 89),
                            ),
                            title: const Text('Change Main Scroll Style').tr(),
                            subtitle: const Text(
                                    'Here you can change your Main Scroll from Modern style to classic style')
                                .tr(),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),

                        //###################   Signout Profile    ######################################
                        GestureDetector(
                          onTap: _signout,
                          child: ListTile(
                            leading: const Icon(
                              Icons.exit_to_app,
                              size: 40,
                              color: Color.fromARGB(255, 220, 102, 6),
                            ),
                            title: const Text('Signout').tr(),
                            subtitle: const Text(
                                    'Exit from this account to enter with another one')
                                .tr(),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),
                        //###################   About App    ######################################
                        ListTile(
                          leading: const Icon(
                            Icons.info_outline_rounded,
                            size: 40,
                            color: Color.fromARGB(255, 97, 32, 155),
                          ),
                          title: const Text('About').tr(),
                          subtitle: const Text('Credits about this app').tr(),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.blueGrey,
                        ),
                        //###################   Admin Panel Profile    ######################################
                        if (widget.snapshot.data!.userType.contains('admin'))
                          GestureDetector(
                            onTap: () => _gotoAdminPanelScreen(snapshot),
                            child: ListTile(
                              leading: const Icon(
                                Icons.admin_panel_settings,
                                size: 40,
                                color: Color.fromARGB(255, 255, 224, 67),
                              ),
                              title: const Text('Admin Panel').tr(),
                              subtitle: const Text(
                                      'Here you take control as administrator')
                                  .tr(),
                            ),
                          ),
                        if (widget.snapshot.data!.userType.contains('admin'))
                          const Divider(
                            thickness: 1,
                            color: Colors.blueGrey,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  //###################   _pickImage Method    ######################################
  Future _pickImage(
      InfoProvider infoProvider, AsyncSnapshot<User> snapshot) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        imageFile = imageTemp;
        infoProvider.toggleImagePicked();
        HttpService.updateUserImage(imageFile!, snapshot.data!.id);
        GlobalSharedPreference.setUserImage(imageFile!.path);
        infoProvider.toggleImageUpdated();
        infoProvider.toggleChangesToServer();
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error Message: $e'),
          duration: const Duration(seconds: 5)));
    }
  }

//###################   _changeUsername Method    ######################################
  void _changeUsername(InfoProvider infoProvider) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change Email').tr(),
            content: TextFormField(
              controller: usernameController,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 18),
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
                            color: Colors.deepPurpleAccent, fontSize: 18))
                    .tr(),
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelStyle: const TextStyle(color: Colors.purple),
                fillColor: Colors.white70,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter a Valid Username'.tr();
                } else if (value.length < 6) {
                  return 'Username must  be 6 characters and greater!'.tr();
                }
                return null;
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    HttpService.updateUserNameInfo(
                            widget.snapshot.data!.id, usernameController.text)
                        .then((value) {
                      if (value.message.contains('Username exists')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Username exists.'),
                                duration: Duration(seconds: 5)));
                      } else if (value.message.contains('User updated')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User updated')));
                        infoProvider.toggleChangesToServer();
                        Navigator.pop(context);
                      }
                    });
                  });
                },
              ),
            ],
          );
        });
  }

//###################   _changeEmail Method    ######################################
  void _changeEmail(InfoProvider infoProvider) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change Email').tr(),
            content: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 18),
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
                            color: Colors.deepPurpleAccent, fontSize: 18))
                    .tr(),
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelStyle: const TextStyle(color: Colors.purple),
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
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    HttpService.updateEmailInfo(
                            widget.snapshot.data!.id, emailController.text)
                        .then((value) {
                      if (value.message.contains('Email exists')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Email exists.'),
                                duration: Duration(seconds: 5)));
                      } else if (value.message.contains('Email updated')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email updated')));
                        infoProvider.toggleChangesToServer();
                        Navigator.pop(context);
                      }
                    });
                  });
                },
              ),
            ],
          );
        });
  }

//###################   _gotoAdminPanelScreen Method    ######################################
  _gotoAdminPanelScreen(AsyncSnapshot<User> snapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminPanelScreen(snapshot)),
    );
  }

//###################   _signout Method    ######################################
  _signout() {
    clearUser().then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }
//###################   clearUser Method    ######################################

  Future clearUser() async {
    await GlobalSharedPreference.clearUserId();
    await GlobalSharedPreference.clearUserEmail();
    await GlobalSharedPreference.clearUserName();
    await GlobalSharedPreference.clearUserImage();
    await GlobalSharedPreference.clearOneTimeLogin();
    await GlobalSharedPreference.clearDoNotShowAlertDialogAgain();
    return Future.value(true);
  }

  _showAletDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        setState(() {
          scrollType.contains('modern')
              ? GlobalSharedPreference.setScrollType('classic')
              : GlobalSharedPreference.setScrollType('modern');
          Navigator.pop(context);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Change Scroll Style").tr(),
      content: Text(scrollType.contains('modern')
          ? "Want to Chage To Classic Style?".tr()
          : "Want to Chage To Modern Style?".tr()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
