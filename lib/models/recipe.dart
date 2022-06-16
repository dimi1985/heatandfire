class Recipe {
  final String recipeId;
  final String recipeName;
  final String recipeImage;
  final String recipeCategoryname;
  final String recipeUserName;
  List<String> ingredients;
  final int recipeDuration;
  final String recipePreparation;
  final String recipeUserImagePath;
  final String userId;
  final String categoryId;
  final bool isLiked;
  List<String> likedByUserIdCount;
  final String createdAt;
  final String recipeDifficulty;
  List<String> comments;
  final String categoryHexColor;
  final String serverMessage;
  final bool isApproved;
  final String categoryGoogleFont;
 
  Recipe({
    required this.recipeId,
    required this.recipeName,
    required this.recipeImage,
    required this.recipeCategoryname,
    required this.recipeDuration,
    required this.recipePreparation,
    required this.recipeUserName,
    required this.ingredients,
    required this.recipeUserImagePath,
    required this.userId,
    required this.categoryId,
    required this.isLiked,
    required this.likedByUserIdCount,
    required this.createdAt,
    required this.recipeDifficulty,
    required this.comments,
    required this.categoryHexColor,
    required this.serverMessage,
    required this.isApproved,
    required this.categoryGoogleFont,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['_id'] ?? '',
      recipeName: json['recipeName'] ?? '',
      recipeImage: json['recipeImage'] ?? '',
      recipeCategoryname: json['recipeCategoryname'] ?? '',
      recipeDuration: json['recipeDuration'] ?? 0,
      recipePreparation: json['recipePreparation'] ?? '',
      recipeUserName: json['recipeUserName'] ?? '',
      ingredients: json['ingredients'] == null
          ? []
          : List<String>.from(json["ingredients"].map((x) => x)),
      likedByUserIdCount: json['likedByUserIdCount'] == null
          ? []
          : List<String>.from(json["likedByUserIdCount"].map((x) => x)),
      recipeUserImagePath: json['recipeUserImagePath'] ?? '',
      userId: json['userId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      isLiked: json['isLiked'] ?? false,
      createdAt: json['createdAt'] ?? '',
      recipeDifficulty: json['recipeDifficulty'] ?? '',
      comments: json['comments'] == null
          ? []
          : List<String>.from(json["comments"].map((x) => x)),
      categoryHexColor: json['categoryHexColor'] ?? '',
      serverMessage: json['message'] ?? '',
      isApproved: json['isApproved'] ?? false,
      categoryGoogleFont: json['categoryGoogleFont'] ?? '',
    );
  }

  @override
  toString() => recipeName;
}
