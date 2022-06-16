import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:provider_tutorial/providers/info_provider.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import '../providers/info_provider.dart';
import 'shared_preference.dart';

class HttpService {
//http://localhost:3000/register
  static var baseUrl = 'http://10.0.2.2:3000/';
  static var registerEndPoint = 'user/register';
  static var loginEndPoint = 'user/login';
  static var getUserIdEndPoint = 'user/getUserId';
  static var getUsersEndPoint = 'user';
  static var getCategoriesEndPoint = 'categories';

  static Future<User> registerUser(
    String username,
    String email,
    String password,
    String imgageFile,
    String userType,
    String createdAt,
  ) async {
    var url = Uri.parse(baseUrl + registerEndPoint);
    var imageDummyPath = r'user-images\dummy-image\dummy-image.jpg';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'username': username,
          'email': email,
          'password': password,
          'userImage': imageDummyPath,
          'userType': userType,
          'createdAt': createdAt,
        },
      ),
    );

    var serverResponse = response.body;

    if (response.statusCode == 201) {
      return User.fromJson(
        jsonDecode(serverResponse),
      );
    } else if (response.statusCode == 409) {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      return User.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      throw Exception('Error With The Server');
    }
  }

  static void updateUserImage(File image, String userId) async {
    var postUri = Uri.parse('$baseUrl' 'user/updateImage/$userId');
    var request = http.MultipartRequest("PATCH", postUri);

    request.headers['Content-Type'] = "multipart/form-data";

    request.files.add(await http.MultipartFile.fromPath('userImage', image.path,
        contentType: MediaType(
          'image',
          'jpeg',
        )));

    request.send().then((response) {
      if (response.statusCode == 201) {}
    });
  }

  static Future<User> loginUser(String email, String password) async {
    var url = Uri.parse(baseUrl + loginEndPoint);

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'email': email,
          'password': password,
        },
      ),
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 404) {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      throw Exception('Error With The Server');
    }
  }

  static Future<User> getUserById() async {
    String userId = await GlobalSharedPreference.getUserID();
    var url = Uri.parse(baseUrl + 'user/$userId');

    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      throw Exception('Error With The Server');
    }
  }

  static Future<User> getUserPublicProfile(userId) async {
    var url = Uri.parse(baseUrl + 'user/$userId');

    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      InfoProvider authProvider = InfoProvider();
      authProvider.toggleHasError();
      throw Exception('Error With The Server');
    }
  }

  static Future<User> getUserId() async {
    var url = Uri.parse(baseUrl + getUserIdEndPoint);
    String email = await GlobalSharedPreference.getUserEmail();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'email': email,
        },
      ),
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<User> updateUserNameInfo(
    String userId,
    String username,
  ) async {
    var url = Uri.parse(baseUrl + 'user/username/$userId/$username');
    List<Map<String, String>> updateOps = [];

    updateOps.add({'propName': "username", "value": username});

    http.Response response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateOps));

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 409) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<User> updateEmailInfo(
    String userId,
    String email,
  ) async {
    var url = Uri.parse(baseUrl + 'user/email/$userId/$email');
    List<Map<String, String>> updateOps = [];

    updateOps.add({'propName': "email", "value": email});

    http.Response response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateOps));

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 409) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 500) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Category> getAllCategories(List<Category> _categories) async {
    var url = Uri.parse('$baseUrl' '$getCategoriesEndPoint');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> categoryData = map["category"];

      for (var i in categoryData) {
        _categories.add(Category.fromJson(i));
      }

      return Category.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Category.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static updateCategoryImage(File pickedImage, String categoryId) async {
    var postUri =
        Uri.parse(baseUrl + 'categories/updateCategoryImage/$categoryId');
    var request = http.MultipartRequest("PATCH", postUri);

    request.headers['Content-Type'] = "multipart/form-data";
    if (pickedImage.path.isEmpty) {}
    request.files.add(
        await http.MultipartFile.fromPath('categoryImage', pickedImage.path,
            contentType: MediaType(
              'image',
              'jpeg',
            )));

    request.send().then((response) {
      if (response.statusCode == 201) {}
      return Future.value(response);
    });
  }

  static Future<Category> updateCategory(
    String categoryId,
    String categoryName,
    String categoryHexColor,
  ) async {
    var url = Uri.parse(baseUrl + 'categories/$categoryId');
    List<Map<String, String>> updateOps = [];

    updateOps.add({'propName': "categoryName", "value": categoryName});
    updateOps.add({'propName': "categoryHexColor", "value": categoryHexColor});

    http.Response response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateOps));

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Category.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> getRecipesByCategory(
      List<Recipe> _recipes, String categoryID) async {
    var url = Uri.parse(baseUrl + 'recipes/getRecipeByCategory/$categoryID');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipies"];

      for (var i in recipeData) {
        _recipes.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<User> getAllUsers(List<User> _users) async {
    String userId = await GlobalSharedPreference.getUserID();
    var url = Uri.parse('$baseUrl' '$getUsersEndPoint');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> userData = map["users"];

      for (var i in userData) {
        _users.add(User.fromJson(i));
      }
      if (_users.any((item) => item.id.contains(userId))) {
        _users.removeWhere((item) => item.id == userId);
      }
      // _users.removeWhere((item) => item.isSocialBothered == false);

      return User.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return User.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<Recipe> getAllRecipies(List<Recipe> _recipes) async {
    var url = Uri.parse(baseUrl + 'recipes');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipe"];

      for (var i in recipeData) {
        _recipes.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<Recipe> getUserRecipes(List<Recipe> _profileRecipes) async {
    String userId = await GlobalSharedPreference.getUserID();

    var url = Uri.parse(baseUrl + 'user/recipes/$userId');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipies"];

      for (var i in recipeData) {
        _profileRecipes.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<Recipe> getPublicUserRecipes(
      String userId, List<Recipe> _profileRecipes) async {
    var url = Uri.parse(baseUrl + 'user/recipes/$userId');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipies"];

      for (var i in recipeData) {
        _profileRecipes.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<Recipe> updateRecipe(
    String recipeId,
    String recipeName,
    String recipeDuration,
    String ingredients,
    String recipePreparation,
    String recipeCategoryname,
    String categoryId,
    String categoryHexColor,
  ) async {
    var url = Uri.parse(baseUrl + 'recipes/$recipeId');
    List<Map<String, String>> updateOps = [];

    updateOps.add({'propName': "recipeName", "value": recipeName});
    updateOps.add({'propName': "recipeDuration", "value": recipeDuration});
    updateOps.add({'propName': "ingredients", "value": ingredients});
    updateOps
        .add({'propName': "recipePreparation", "value": recipePreparation});

    updateOps
        .add({'propName': "recipeCategoryname", "value": recipeCategoryname});
    updateOps.add({'propName': "categoryId", "value": categoryId});
    updateOps.add({'propName': "categoryHexColor", "value": categoryHexColor});
    http.Response response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateOps));

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> approveRecipe(
      String recipeId, bool booleanValue) async {
    var url =
        Uri.parse(baseUrl + 'recipes/approveRecipe/$recipeId/$booleanValue');

    final http.Response response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> getRecipiesSortBy(List<Recipe> _mainRecipies) async {
    var url = Uri.parse(baseUrl + 'recipes/sortby');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipe"];

      for (var i in recipeData) {
        _mainRecipies.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<Recipe> deleteRecipe(String recipeId, String userId,
      String categoryId, String recipeImage) async {
    var url =
        Uri.parse(baseUrl + 'recipes/delete/$recipeId/$userId/$categoryId');

    final http.Response response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'recipeImage': recipeImage,
        },
      ),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static updateRecipeImage(File pickedImage, String recipeId) async {
    var postUri = Uri.parse(baseUrl + 'recipes/updateImage/$recipeId');
    var request = http.MultipartRequest("PATCH", postUri);

    request.headers['Content-Type'] = "multipart/form-data";
    if (pickedImage.path.isEmpty) {}
    request.files
        .add(await http.MultipartFile.fromPath('recipeImage', pickedImage.path,
            contentType: MediaType(
              'image',
              'jpeg',
            )));

    request.send().then((response) {
      if (response.statusCode == 201) {}
      return Future.value(response);
    });
  }

  static Future<Recipe> updateRecipeCategoryName(
      String recipeId, String oldCategoryId, String newCategoryId) async {
    var url = Uri.parse(baseUrl +
        'recipes/updateRecipeCategoryId/$recipeId/$oldCategoryId/$newCategoryId');

    final http.Response response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'recipeId': recipeId,
          'oldCategoryId': oldCategoryId,
          'newCategoryId': newCategoryId,
        },
      ),
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    }
    if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }




  static Future<User> sendUserFollow(String userA, String userB) async {
    var url = Uri.parse(baseUrl + 'user/userFollow/$userA/$userB');

    final http.Response response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

   static Future<User> sendUserFollowBack(String userA, String userB) async {
    var url = Uri.parse(baseUrl + 'user/userFollowBack/$userA/$userB');

    final http.Response response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

   
  static Future<User> sendUserUnFollow(String userA, String userB) async {
    var url = Uri.parse(baseUrl + 'user/userUnfollow/$userA/$userB');

    final http.Response response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }



  static Future<Recipe> likeRecipe(
      String recipeId, String user, bool booleanValue) async {
    var url =
        Uri.parse(baseUrl + 'recipes/likeRecipe/$recipeId/$user/$booleanValue');
    print('from hhtp url: $url');

    final http.Response response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> dislikeRecipe(String recipeId, String user) async {
    var url = Uri.parse(baseUrl + 'recipes/dislikeRecipe/$recipeId/$user');

    final http.Response response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<User> getUserFriendsStatus(List<User> _users) async {
    String userId = await GlobalSharedPreference.getUserID();

    var url = Uri.parse(baseUrl + 'user/friendStatus/$userId');

    final http.Response response = await http.get(
      url,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> friendData = map["friends"];

      for (var i in friendData) {
         
        _users.add(User.fromJson(i));
        
      }

      return User.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return User.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }
}
