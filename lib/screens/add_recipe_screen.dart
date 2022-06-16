import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/models/recipe.dart';
import 'package:provider_tutorial/util/http_service.dart';
import '../models/category.dart';
import '../providers/info_provider.dart';
import '../util/shared_preference.dart';
import 'success_add_edit_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddRecipeScreen extends StatefulWidget {
  final AsyncSnapshot<Recipe> snapshot;
  const AddRecipeScreen(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  final preparationController = TextEditingController();
  late File _pickedImage = File('');

  final List<Category> _categories = [];
  late Future<Category> _futureCategory;

  int selectedIndex = 0;

  var nameRecipe = '';
  var durationRecipe = '';
  var durationPreparation = '';

  final List<String> ingredientList = [];

  final List<TextEditingController> _controllers = [];
  final List<TextFormField> _fields = [];

  List<DropdownMenuItem<String>> get dropdownItemsDifficulty {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: const Text("Easy").tr(), value: "Easy"),
      DropdownMenuItem(child: const Text("Advanded").tr(), value: "Advanded"),
      DropdownMenuItem(child: const Text("Hard").tr(), value: "Hard"),
    ];
    return menuItems;
  }

  String selectedValueDiffiCulty = "Easy";

  @override
  void initState() {
    _futureCategory =
        HttpService.getAllCategories(_categories).then((value) async {
      return Future.value(value);
    });

    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    durationController.dispose();
    preparationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(builder: (context, infoProvider, child) {
      return FutureBuilder<Category>(
          future: _futureCategory,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: HexColor(_getCategoryColor(selectedIndex)),
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            HexColor(
                              _getCategoryColor(selectedIndex),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            infoProvider.isLoading = false;
                            infoProvider.isUploaded = false;
                            _showSheet(context, infoProvider);
                          });
                        },
                        child: const Text(
                          'Preview',
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ),
                    )
                  ],
                  title: const Text(
                    'Add Recipe',
                    style: TextStyle(
                        fontFamily: 'Caudex',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ).tr(),
                ),
                body: AnimatedContainer(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        HexColor(_getCategoryColor(selectedIndex)),
                        Colors.white,
                      ],
                    ),
                  ),
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: ListView(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            _pickedImage.path.isEmpty
                                ? Container(
                                    height: 150,
                                  )
                                : Image.file(
                                    _pickedImage,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.fitWidth,
                                  ),
                            Positioned(
                              bottom: 10,
                              left: 130,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    HexColor(
                                      _getCategoryColor(selectedIndex),
                                    ),
                                  ),
                                ),
                                onPressed: _pickImage,
                                icon: const Icon(
                                  Icons.photo_album_outlined,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Add Photo',
                                  style: TextStyle(color: Colors.white),
                                ).tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: SizedBox(
                            height: 40.0, // 35
                            child: FutureBuilder<Category>(
                                future: _futureCategory,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _categories.length,
                                      itemBuilder: (context, index) =>
                                          listCategoryItems(index),
                                    );
                                  }
                                  return const Text('Loading...').tr();
                                })),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: const Text('Difficulty:').tr()),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                  underline: Container(), //empty line
                                  value: selectedValueDiffiCulty,
                                  isExpanded: true,
                                  dropdownColor: Colors.blueGrey,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValueDiffiCulty = newValue!;
                                    });
                                  },
                                  items: dropdownItemsDifficulty,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Form(
                          key: _formKey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextFormField(
                                    controller: nameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(20.0),
                                        hintText: 'Name Recipe'.tr(),
                                        border: InputBorder.none,
                                        hintStyle: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15.0),
                                        hintMaxLines: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextFormField(
                                    controller: durationController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(20.0),
                                      hintText: 'Preparation Duration'.tr(),
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Row(children: [
                                  const Text('Press + to Add Recipe').tr(),
                                  IconButton(
                                      onPressed: _addTextFields,
                                      icon: const Icon(Icons.add))
                                ]),
                              ),
                              Expanded(child: _listView()),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: SizedBox(
                              height: 200,
                              child: TextFormField(
                                controller: preparationController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 100,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20.0),
                                  border: InputBorder.none,
                                  hintText:
                                      'First we cut the vegetables and...'.tr(),
                                  hintStyle:
                                      const TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    });
  }

  _getCategoryName(int selectedIndex) {
    return _categories[selectedIndex];
  }

  _getRecipeName() {
    return nameController.text;
  }

  _getRecipeDuration() {
    return durationController.text;
  }

  _getRecipePreparation() {
    return preparationController.text;
  }

  _getDifficulty() {
    return selectedValueDiffiCulty;
  }

  _getCategoryID(int index) {
    var catId = _categories[index].categoryId;

    return catId;
  }

  _getCategoryColor(int index) {
    var catColor = _categories[index].categoryHexColor;

    return catColor;
  }

  _getCategoryFont(int index) {
    GlobalSharedPreference.clearTempGoogleFont();
    var catFont = _categories[index].categoryGoogleFont;
    GlobalSharedPreference.setTempGoogleFont(catFont);
    return catFont;
  }

  void _showSheet(BuildContext context, InfoProvider infoProvider) {
    showModalBottomSheet(
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
                        child: _pickedImage.path.isEmpty
                            ? Center(
                                child: const Text(
                                  'Please Select an Image',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ).tr(),
                              )
                            : Image.file(
                                _pickedImage,
                                fit: BoxFit.cover,
                              ),
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
                          title: Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.0,
                                color: HexColor(
                                  _getCategoryColor(selectedIndex),
                                ),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child:
                                Text(_getCategoryName(selectedIndex).toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: HexColor(
                                        _getCategoryColor(selectedIndex),
                                      ),
                                      fontWeight: FontWeight.w500,
                                    )),
                          ),
                          subtitle: Text(
                            _getRecipeName(),
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
                                    _getDifficulty(),
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
                                    _getRecipeDuration(),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  const Text(
                                    'min',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ).tr()
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            "INGREDIENTS",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ).tr(),
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
                                  _getRecipeIngredients()
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            "PREPARATION",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ).tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 32),
                          child: Text(
                            _getRecipePreparation(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            child: infoProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : !infoProvider.isUploaded
                                    ? const Text('Upload').tr()
                                    : const Icon(Icons.check),
                            onPressed: infoProvider.isLoading
                                ? null
                                : () {
                                    if (mounted) {
                                      bottomSheetState(() {
                                        infoProvider.isLoading = true;
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SuccesAddEditScreen(
                                                    'add'),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                        saveRecipeToServer(
                                            bottomSheetState, infoProvider);
                                      });
                                    }
                                  }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  _pickImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library').tr(),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera').tr(),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _imgFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  void _imgFromCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  Widget listCategoryItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          _getCategoryID(index);
          _getCategoryColor(index);
          _getCategoryFont(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0, //20
          vertical: 10.0, //5
        ),
        decoration: BoxDecoration(
            color: selectedIndex == index
                ? const Color(0xFFEFF3EE)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          _categories[index].categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedIndex == index
                ? ThemeData.estimateBrightnessForColor(
                            HexColor(_getCategoryColor(selectedIndex))) ==
                        Brightness.light
                    ? Colors.red
                    : Colors.orange
                : const Color(0xFFEFF3EE),
          ),
        ),
      ),
    );
  }

  void _addTextFields() {
    var field = TextFormField();
    final controller = TextEditingController();
    field = TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20.0),
          hintText: 'Add Ingredient'.tr(),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
          suffixIcon: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _fields.remove(field);
                _controllers.remove(controller);
              });
            },
          )),
    );

    setState(() {
      _controllers.add(controller);
      _fields.add(field);
    });
  }

  _listView() {
    return LimitedBox(
      child: ListView.builder(
        itemCount: _fields.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(5),
            child: _fields[index],
          );
        },
      ),
    );
  }

  _getRecipeIngredients() {
    ingredientList.clear();
    for (int i = 0; i < _controllers.length; i++) {
      ingredientList.add(_controllers[i].text);
    }

    return ingredientList;
  }

  Future saveRecipeToServer(
      StateSetter bottomSheetState, InfoProvider infoProvider) async {
    String createdAt =
        DateFormat("MMM, EEE, yyyy, kk:mm").format(DateTime.now());
    String userId = await GlobalSharedPreference.getUserID();
    String username = await GlobalSharedPreference.getUserName();
    String userImage = await GlobalSharedPreference.getUserImage();

    var postUri = Uri.parse("http://10.0.2.2:3000/recipes");
    var request = http.MultipartRequest("POST", postUri);

    request.fields['ingredients'] =
        ingredientList.toString().replaceAll("[", "").replaceAll("]", "");
    request.fields['recipeDuration'] = _getRecipeDuration();
    request.fields['recipeName'] = _getRecipeName();
    request.fields['recipePreparation'] = _getRecipePreparation();
    request.fields['recipeCategoryname'] =
        _getCategoryName(selectedIndex).toString();
    request.files
        .add(await http.MultipartFile.fromPath('recipeImage', _pickedImage.path,
            contentType: MediaType(
              'image',
              'jpeg',
            )));
    request.fields['recipeUserImagePath'] = userImage;
    request.fields['categoryId'] = _getCategoryID(selectedIndex);
    request.fields['userId'] = userId;

    request.fields['recipeUserName'] = username;
    request.fields['createdAt'] = createdAt;
    request.fields['recipeDifficulty'] = selectedValueDiffiCulty;
    request.fields['categoryHexColor'] = _getCategoryColor(selectedIndex);
    request.fields['categoryGoogleFont'] = _getCategoryFont(selectedIndex);
    request.headers['Content-Type'] = "multipart/form-data";
    print('From Add Recipe: ${_getCategoryFont(selectedIndex)}');
    request.send().then((response) {
      if (response.statusCode == 201) {
        if (mounted) {
          bottomSheetState(() {
            infoProvider.isLoading = false;
            infoProvider.isUploaded = true;
          });
        }
      }
    });
  }
}
