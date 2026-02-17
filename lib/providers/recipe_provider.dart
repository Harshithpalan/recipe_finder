import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _service = RecipeService();
  
  // State: API Results
  List<Recipe> _recipes = [];
  bool _loading = false;
  String? _error;

  // State: User Inputs
  String _searchQuery = '';
  String _selectedDiet = 'All';

  // State: Local Persistence (Saved Recipes)
  final List<RecipeModel> _savedRecipes = [];
  static const String _boxName = 'recipes';

  List<Recipe> get recipes => _recipes;
  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedDiet => _selectedDiet;
  List<RecipeModel> get savedRecipes => _savedRecipes;

  RecipeProvider() {
    _loadSavedRecipes();
  }

  // --- Search & Filter Management ---

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSelectedDiet(String diet) {
    _selectedDiet = diet;
    notifyListeners();
  }

  Future<void> searchRecipes() async {
    _loading = true;
    _error = null;
    notifyListeners();

    String? diet;
    int? maxReadyTime;
    String? intolerances;

    if (_selectedDiet == 'Vegetarian') {
      diet = 'vegetarian';
    } else if (_selectedDiet == 'Quick Meals') {
      maxReadyTime = 30;
    } else if (_selectedDiet == 'Gluten Free') {
      intolerances = 'gluten';
    } else if (_selectedDiet == 'Vegan') {
      diet = 'vegan';
    } else if (_selectedDiet == 'Ketogenic') {
      diet = 'ketogenic';
    }

    try {
      _recipes = await _service.fetchRecipes(
        _searchQuery, 
        diet: diet,
        maxReadyTime: maxReadyTime,
        intolerances: intolerances,
      );
      if (_recipes.isEmpty) {
        _error = "No recipes found. Try a different search.";
      }
    } catch (e) {
      // Offline fallback: Show saved recipes if API fails
      _recipes = _savedRecipes.map((model) => Recipe(
        id: model.id,
        title: model.title,
        image: model.image,
        duration: model.duration,
        rating: model.rating,
      )).toList();
      
      if (e.toString().contains("API Quota Exceeded")) {
        _error = "Daily API limit reached. Showing saved recipes.";
      } else if (_recipes.isEmpty) {
        _error = "Failed to load recipes. Please check your connection.";
      } else {
        _error = "Offline mode: Showing your saved recipes.";
      }
      debugPrint("Error fetching recipes: $e");
    }

    _loading = false;
    notifyListeners();
  }

  // --- Local Persistence (Hive) ---

  void _loadSavedRecipes() {
    final box = Hive.box<RecipeModel>(_boxName);
    _savedRecipes.clear();
    _savedRecipes.addAll(box.values);
    notifyListeners();
  }

  bool isSaved(int id) {
    return Hive.box<RecipeModel>(_boxName).containsKey(id);
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final box = Hive.box<RecipeModel>(_boxName);
    if (isSaved(recipe.id)) {
      await box.delete(recipe.id);
      _savedRecipes.removeWhere((r) => r.id == recipe.id);
    } else {
      final model = RecipeModel(
        id: recipe.id,
        title: recipe.title,
        image: recipe.image,
        duration: recipe.duration,
        rating: recipe.rating,
      );
      await box.put(recipe.id, model);
      _savedRecipes.add(model);
    }
    notifyListeners();
  }
}
