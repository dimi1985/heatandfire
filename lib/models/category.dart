class Category {
  final String categoryId;
  final String categoryName;
  List<String> recipeId;

  final String categoryImage;
  final String categoryHexColor;
  final String categoryGoogleFont;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.recipeId,
    required this.categoryHexColor,
    required this.categoryGoogleFont,
  });

  factory Category.fromJson(Map<dynamic, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryImage: json['categoryImage'] ?? '',
      recipeId: json['recipeId'] == null
          ? []
          : List<String>.from(json["recipeId"].map((x) => x)),
      categoryHexColor: json['categoryHexColor'] ?? '',
      categoryGoogleFont: json['categoryGoogleFont'] ?? '',
    );
  }

  @override
  toString() => categoryName;
}
