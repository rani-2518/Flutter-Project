import 'package:flutter/foundation.dart';

import '../models/recipe.dart';
import '../services/api_service.dart';

enum LoadStatus { loading, success, error }

class RecipeProvider extends ChangeNotifier {
  final ApiService _api;

  RecipeProvider({ApiService? api}) : _api = api ?? ApiService();

  LoadStatus _status = LoadStatus.loading;
  List<Recipe> _recipes = [];
  String _query = '';
  String _errorMessage = '';

  LoadStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get query => _query;
  int get totalCount => _recipes.length;

  /// Recipes filtered by title, cuisine, tags or meal type.
  List<Recipe> get filteredRecipes {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _recipes;

    return _recipes.where((r) {
      return r.name.toLowerCase().contains(q) ||
          r.cuisine.toLowerCase().contains(q) ||
          r.tags.any((t) => t.toLowerCase().contains(q)) ||
          r.mealType.any((m) => m.toLowerCase().contains(q));
    }).toList();
  }

  Future<void> fetchRecipes({bool showLoader = true}) async {
    if (showLoader) {
      _status = LoadStatus.loading;
      _query = '';
      notifyListeners();
    }

    try {
      _recipes = await _api.fetchRecipes();
      _status = LoadStatus.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }
}
