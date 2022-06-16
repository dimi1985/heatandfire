import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/util/http_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider_tutorial/util/shared_preference.dart';
import '../util/color_pallette.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../providers/info_provider.dart';

class AdminPanelCategories extends StatefulWidget {
  const AdminPanelCategories({Key? key}) : super(key: key);

  @override
  State<AdminPanelCategories> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminPanelCategories> {
  late List<Category> _categories = [];
  late Future<Category> _futureCategory;
  final List<Recipe> _recipies = [];

  var nameController = TextEditingController();

  var hexColorController = TextEditingController();

  var googleFontController = TextEditingController();

  File? imageFile;

  @override
  void initState() {
    _futureCategory = HttpService.getAllCategories(_categories);
    _categories = _categories.toSet().toList(); // <---- Solved Duplicates
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
   super.setState(() {
      _futureCategory = HttpService.getAllCategories(_categories);
   });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(
      builder: (context, infoProvider, child) {
      return Scaffold(
        appBar: AppBar(
          
        ),
        body: FutureBuilder<Category>(
        future: _futureCategory,
        builder: (context, snapshot) {
          return _categories.isEmpty
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('No Data').tr(),
                      ElevatedButton(
                        onPressed: (() => _showAddCatBottomSheet(infoProvider)),
                        child: const Text('Add Category').tr(),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            var category = _categories[index];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    ColorPallete.emptyBackroundImageColor,
                                child: ClipOval(
                                  child: Image.network(
                                    (category.categoryImage)
                                        .replaceAll(r'\', '/'),
                                    fit: BoxFit.cover,
                                    width: 60.0,
                                    height: 60.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color.fromARGB(
                                            255, 188, 188, 189),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Whoops!'.tr(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                radius: 25,
                              ),
                              title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.0,
                                          color: HexColor(
                                              category.categoryHexColor),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Text(
                                        category.categoryName,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.info_outline,
                                        size: 30,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        _showCategoryDetailsBottomSheet(
                                            _categories,
                                            index,
                                            category.categoryId);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 30,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        _showEditCatBottomSheet(_categories,
                                            index, category, infoProvider);
                                      },
                                    )
                                  ]),
                            );
                          }),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          _showAddCatBottomSheet(infoProvider);
                        },
                        child: const Text('Add Category').tr(),
                      )
                    ],
                  ),
                );
        },
      ),
      );
    });
  }

  _showAddCatBottomSheet(InfoProvider infoProvider) {
    GlobalSharedPreference.clearTempGoogleFont();
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          infoProvider.isUploaded = false;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: kToolbarHeight / 0.3,
                          child: imageFile != null
                              ? Image.file(File(imageFile?.path ?? ''))
                              : Image.asset('assets/images/placeholder.png'),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.photo_album),
                          label: const Text('Add Photo').tr(),
                          onPressed: () {
                            _pickImage(setState);
                          },
                        )
                      ],
                    ),
                    TextField(
                      controller: nameController,
                      decoration:
                          InputDecoration(hintText: 'Category Name'.tr()),
                    ),
                    TextField(
                      controller: hexColorController,
                      decoration:
                          InputDecoration(hintText: 'Category HexColor'.tr()),
                    ),
                    TextField(
                      controller: googleFontController,
                      decoration: InputDecoration(
                          hintText: 'Category Google Font'.tr()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        saveToServer(setState, infoProvider).whenComplete(() {
                          if (!infoProvider.isLoading &&
                              infoProvider.isUploaded) {
                            setState(() {
                              Navigator.pop(context);
                            });
                            
                          }
                        });
                      },
                      child: infoProvider.isLoading
                          ? const CircularProgressIndicator()
                          : infoProvider.isUploaded
                              ? const Icon(Icons.check)
                              : const Text('Submit').tr(),
                    )
                  ],
                ),
              ),
            );
          });
        }).whenComplete(() {});
  }

  Future _pickImage(StateSetter setState) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        imageFile = imageTemp;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error Message: $e'),
          duration: const Duration(seconds: 5)));
    }
  }

  Future saveToServer(StateSetter setState, InfoProvider infoProvider) async {
    var postUri = Uri.parse("http://10.0.2.2:3000/categories");
    var request = http.MultipartRequest("POST", postUri);

    request.files
        .add(await http.MultipartFile.fromPath('categoryImage', imageFile!.path,
            contentType: MediaType(
              'image',
              'jpeg',
            )));

    request.fields['categoryName'] = nameController.text.trim();
    request.fields['categoryHexColor'] = hexColorController.text.trim();
    request.fields['categoryGoogleFont'] = googleFontController.text.trim();

    request.headers['Content-Type'] = "multipart/form-data";

    request.send().then((response) {
      if (response.statusCode == 201) {
        if (mounted) {
          setState(() {
            infoProvider.isLoading = false;
            infoProvider.isUploaded = true;
            GlobalSharedPreference.setTempGoogleFont(
                googleFontController.text.trim());
          });

        }
      }
    });
  }

  _showEditCatBottomSheet(List<Category> categories, int index,
      Category category, InfoProvider infoProvider) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          infoProvider.isUploaded = false;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: 400,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: kToolbarHeight / 0.3,
                          child: imageFile != null
                              ? Image.file(File(imageFile?.path ?? ''))
                              : Image.asset('assets/images/placeholder.png'),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.photo_album),
                          label: const Text('Add Photo').tr(),
                          onPressed: () {
                            _pickImage(setState);
                          },
                        )
                      ],
                    ),
                    TextField(
                      controller: nameController = TextEditingController()
                        ..text = categories[index].categoryName,
                    ),
                    TextField(
                      controller: hexColorController = TextEditingController()
                        ..text = categories[index].categoryHexColor,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateToServer(setState, category, infoProvider);
                      },
                      child: infoProvider.isLoading
                          ? const CircularProgressIndicator()
                          : infoProvider.isUploaded
                              ? const Icon(Icons.check)
                              : const Text('Update').tr(),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  updateToServer(StateSetter setState, category, InfoProvider infoProvider) {
    setState(() {
      infoProvider.isLoading = true;
      infoProvider.isUploaded = false;
    });

    return HttpService.updateCategory(
      category.categoryId,
      nameController.text,
      hexColorController.text,
    ).then((value) {
      HttpService.updateCategoryImage(
          File(imageFile?.path ?? ''), category.categoryId);
    }).whenComplete(() => setState(() {
          infoProvider.isLoading = false;
          infoProvider.isUploaded = true;
        }));
  }

  _showCategoryDetailsBottomSheet(
      List<Category> categories, int index, String categoryId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 400,
              child: Column(
                children: [
                  Text(
                    categories[index].categoryName,
                  ),
                  FutureBuilder(
                    future: HttpService.getRecipesByCategory(
                        _recipies, categories[index].categoryId),
                    builder: (context, snapshot) {
                      return Text(categories[index].recipeId.toString());
                    },
                  ),
                ],
              ),
            );
          });
        });
  }
}
