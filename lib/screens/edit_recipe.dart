import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider_tutorial/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../models/category.dart';
import '../util/http_service.dart';
import 'success_add_edit_screen.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipeItem;
  const EditRecipeScreen(this.recipeItem, {Key? key}) : super(key: key);

  @override
  State<EditRecipeScreen> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipeScreen> {
  late File pickedImage = File('');
  var picker = ImagePicker();
  late bool isLoading = false;
  late bool isUpdated = false;
  late bool isNewCategoryChoosed = false;
  late bool areEqual = false;
  final List<Category> _categories = [];
  late Future<Category> _futureCategory;

  int selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  var textFieldRecipeNameEdit = TextEditingController();
  var textFieldRecipeDurationEdit = TextEditingController();
  var textFieldRecipeIngrendsEdit = TextEditingController();
  var textFieldRecipPrepEdit = TextEditingController();

  @override
  void initState() {
    _futureCategory = HttpService.getAllCategories(_categories);

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textFieldRecipeNameEdit.dispose();
    textFieldRecipeDurationEdit.dispose();
    textFieldRecipeIngrendsEdit.dispose();
    textFieldRecipPrepEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Edit Recipe',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  pickedImage.path.isEmpty
                      ? Image.network(
                          'http://10.0.2.2:3000/${(widget.recipeItem.recipeImage).replaceAll(r'\', '/')}',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.file(
                          pickedImage,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.fitWidth,
                        ),
                  Positioned(
                    bottom: 10,
                    left: 130,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink[400]),
                      ),
                      onPressed: _pickImage,
                      icon: const Icon(
                        Icons.photo_album_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: _showBottomSheet,
                    icon: isNewCategoryChoosed
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent,
                          )
                        : const Icon(Icons.edit),
                    label: Text(isNewCategoryChoosed
                        ? _getCategoryName(selectedIndex).toString()
                        : widget.recipeItem.recipeCategoryname)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Edit Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: textFieldRecipeNameEdit =
                                  TextEditingController()
                                    ..text = widget.recipeItem.recipeName,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Edit Duration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: textFieldRecipeDurationEdit =
                                  TextEditingController()
                                    ..text = widget.recipeItem.recipeDuration
                                        .toString(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                      const Text(
                          'Edit Ingredients',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller:
                        textFieldRecipeIngrendsEdit = TextEditingController()
                          ..text = widget.recipeItem.ingredients
                              .toString()
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20.0),
                    ),
                  ),
                ),
              ),
                ],
              ),
              Column(
                children: [
                     const Text(
                          'Edit Preparation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: SizedBox(
                    height: 190.0,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        controller:
                            textFieldRecipPrepEdit = TextEditingController()
                              ..text = widget.recipeItem.recipePreparation,
                        maxLines: 100,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _updateToServer();
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : isUpdated
                              ? const Icon(Icons.check)
                              : const Text('Update')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
        HttpService.updateRecipeImage(pickedImage, widget.recipeItem.recipeId);
      } else {}
    });
  }

  void _imgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
        HttpService.updateRecipeImage(pickedImage, widget.recipeItem.recipeId);
      }
    });
  }

  _updateToServer() {
    setState(() {
      isLoading = true;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccesAddEditScreen('update'),
        ),
        (Route<dynamic> route) => false,
      );
    });

    return HttpService.updateRecipe(
      widget.recipeItem.recipeId,
      textFieldRecipeNameEdit.text.trim(),
      textFieldRecipeDurationEdit.text.trim(),
      textFieldRecipeIngrendsEdit.text.trim(),
      textFieldRecipPrepEdit.text.trim(),
      isNewCategoryChoosed
          ? _getCategoryName(selectedIndex).toString()
          : widget.recipeItem.recipeCategoryname,
      _getCagoryID(selectedIndex),
      isNewCategoryChoosed
          ? _getCategoryColor(selectedIndex)
          : widget.recipeItem.categoryHexColor,
    ).then((value) {
      if (isNewCategoryChoosed) {
        HttpService.updateRecipeCategoryName(widget.recipeItem.recipeId,
            widget.recipeItem.categoryId, _getCagoryID(selectedIndex));
      }

      return Future.value(value);
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
          isUpdated = true;
        });
      }
    });
  }

  Widget listCategoryItems(int index, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;

          _getCagoryID(index);
          Navigator.pop(context);
          isNewCategoryChoosed = true;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0, //20
          vertical: 10.0, //5
        ),
        decoration: BoxDecoration(
            // color:
            //     selectedIndex == index ? Color(0xFFEFF3EE) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          _categories[index].categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedIndex == index
                ? Colors.deepOrange
                : const Color(0xFFC2C2B5),
          ),
        ),
      ),
    );
  }

  _getCagoryID(int index) {
    var catId = _categories[index].categoryId;

    return catId;
  }

  _getCategoryName(int selectedIndex) {
    return _categories[selectedIndex];
  }

  _getCategoryColor(int index) {
    var catColor = _categories[index].categoryHexColor;

    return catColor;
  }

  _showBottomSheet() {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
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
                                listCategoryItems(index, setState),
                          );
                        }
                        return const Text('Loading...');
                      })),
            );
          });
        }).whenComplete(() {
      setState(() {
        if (selectedIndex != selectedIndex) {
          isNewCategoryChoosed = true;
        }
      });
    });
  }
}
