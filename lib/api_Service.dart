
import "dart:convert";
import "package:http/http.dart" as http;
import "package:lakreset/models.dart";

class APIService{

  final String baseURL = "https://dummyjson.com";

  Future <List<Recipes>> getRecipes() async {
    final response = await http.get(Uri.parse('$baseURL/recipes'));
    if (response.statusCode == 200){
      final data = json.decode(response.body);
      final List<dynamic> recipesJson= data['recipes'];
      return recipesJson
          .map((el) => Recipes.fromJson(el))
          .toList();
    } else {
      throw Exception('pa ka load done yo');
    }
  }
}