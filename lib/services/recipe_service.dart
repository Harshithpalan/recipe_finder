import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  final String apiKey = "447719d79b6d4f66a0b7e724343aed61";
  final String baseUrl = "https://api.spoonacular.com/recipes/complexSearch";

  Future<List<Recipe>> fetchRecipes(String query, {
    String? diet,
    int? maxReadyTime,
    String? intolerances,
  }) async {
    // Spoonacular complexSearch API parameters
    final Map<String, String> queryParams = {
      'query': query,
      'number': '10',
      'apiKey': apiKey,
      'addRecipeInformation': 'true', // Needed for readyInMinutes and spoonacularScore
    };

    if (diet != null && diet.isNotEmpty && diet != 'All') {
      queryParams['diet'] = diet.toLowerCase();
    }
    if (maxReadyTime != null) {
      queryParams['maxReadyTime'] = maxReadyTime.toString();
    }
    if (intolerances != null && intolerances.isNotEmpty) {
      queryParams['intolerances'] = intolerances;
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } else if (response.statusCode == 402) {
      throw Exception("API Quota Exceeded. Please use a new key.");
    } else {
      throw Exception("Failed to load recipes: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> fetchRecipeInformation(int id) async {
    final url = Uri.parse("https://api.spoonacular.com/recipes/$id/information?apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 402) {
      throw Exception("API Quota Exceeded.");
    } else {
      throw Exception("Failed to load recipe details: ${response.statusCode}");
    }
  }
}
