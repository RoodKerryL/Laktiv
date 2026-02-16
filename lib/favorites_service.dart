import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:lakreset/models.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_Recettes';

  static Future<List<Recettes>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      return favoritesJson.map((jsonStr) {
        return Recettes.fromJson(json.decode(jsonStr));
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Set<int>> getFavoriteIds() async {
    try {
      final favorites = await getFavorites();
      return favorites.map((recette) => recette.id).toSet();
    } catch (e) {
      return {};
    }
  }

  static Future<bool> isFavorite(int recetteId) async {
    final favoriteIds = await getFavoriteIds();
    return favoriteIds.contains(recetteId);
  }

  static Future<bool> addFavorite(Recettes recette) async {
    try {
      final favorites = await getFavorites();
      
      if (favorites.any((r) => r.id == recette.id)) {
        return false; 
      }
      
      favorites.add(recette);
      await _saveFavorites(favorites);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeFavorite(int recetteId) async {
    try {
      final favorites = await getFavorites();
      final initialLength = favorites.length;
      
      favorites.removeWhere((r) => r.id == recetteId);
      
      if (favorites.length < initialLength) {
        await _saveFavorites(favorites);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> toggleFavorite(Recettes recette) async {
    final isCurrentlyFavorite = await isFavorite(recette.id);
    
    if (isCurrentlyFavorite) {
      return await removeFavorite(recette.id);
    } else {
      return await addFavorite(recette);
    }
  }

  static Future<void> _saveFavorites(List<Recettes> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favorites.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

}