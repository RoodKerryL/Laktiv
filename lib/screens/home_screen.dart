import 'package:flutter/material.dart';
import 'package:lakreset/api_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'detail_screen.dart';
import 'package:lakreset/models.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onFavoriteChanged;
  
  const HomeScreen({super.key, this.onFavoriteChanged});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final APIService apiService = APIService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Recettes> _allRecettes = [];
  List<Recettes> _filteredRecettes = [];
  Set<int> _favoriteIds = {};
  bool _isLoading = true;
  String? _error;
  bool _isNetworkError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadRecettes();
    await loadFavoriteIds();
  }

  bool _checkIfNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('socketexception') ||
           errorString.contains('failed host lookup') ||
           errorString.contains('no address associated with hostname') ||
           errorString.contains('network') ||
           errorString.contains('connection refused') ||
           errorString.contains('connection timeout');
  }

  Future<void> _loadRecettes() async {
    try {
      final Recettes = await APIService.getRecette();
      if (mounted) {
        setState(() {
          _allRecettes = Recettes;
          _filteredRecettes = Recettes;
          _isLoading = false;
          _error = null;
          _isNetworkError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isNetworkError = _checkIfNetworkError(e);
          if (_isNetworkError) {
            _error = 'Pa gen koneksyon entènèt';
          } else {
            _error = e.toString();
          }
          _isLoading = false;
        });
      }
    }
  }

  Future<void> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorite_Recettes') ?? [];
    
    final ids = favoritesJson.map((jsonStr) {
      try {
        final Recette = Recettes.fromJson(json.decode(jsonStr));
        return Recette.id;
      } catch (e) {
        return 0;
      }
    }).where((id) => id != 0).toSet();
    
    if (mounted) {
      setState(() {
        _favoriteIds = ids;
      });
    }
  }

  Future<void> _toggleFavorite(Recettes Recette) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorite_Recettes') ?? [];
    
    List<Recettes> favoriteRecettes = [];
    for (String jsonStr in favoritesJson) {
      try {
        favoriteRecettes.add(Recettes.fromJson(json.decode(jsonStr)));
      } catch (e) {
        continue;
      }
    }
    
    bool isFavorite = _favoriteIds.contains(Recette.id);
    
    if (isFavorite) {
      favoriteRecettes.removeWhere((r) => r.id == Recette.id);
      _favoriteIds.remove(Recette.id);
    } else {
      favoriteRecettes.add(Recette);
      _favoriteIds.add(Recette.id);
    }
    
    final updatedJson = favoriteRecettes.map((r) => json.encode(r.toJson())).toList();
    
    await prefs.setStringList('favorite_Recettes', updatedJson);
    
    if (mounted) {
      setState(() {});
      
      widget.onFavoriteChanged?.call();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite 
                ? '${Recette.name} retire nan favori' 
                : '${Recette.name} ajoute nan favori'
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _filterRecettes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecettes = _allRecettes;
      } else {
        _filteredRecettes = _allRecettes.where((Recette) {
          return Recette.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lis Resèt',
          style: TextStyle(
            color: Colors.white,
          ),
          ),
        backgroundColor: Colors.orange[800],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isNetworkError ? Icons.wifi_off : Icons.error_outline,
                          size: 64,
                          color: _isNetworkError ? Colors.orange : Colors.red,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _isNetworkError 
                              ? 'Pa gen koneksyon entènèt'
                              : 'Yon erè rive',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isNetworkError
                              ? 'Tanpri verifye koneksyon entènèt ou epi eseye ankò'
                              : _error!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                              _isNetworkError = false;
                            });
                            _loadData();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Eseye ankò'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Chèche resèt...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterRecettes('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: _filterRecettes,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _filteredRecettes.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchController.text.isEmpty
                                          ? 'Pa gen resèt'
                                          : 'Okenn resèt pa jwenn pou "${_searchController.text}"',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _filteredRecettes.length,
                                itemBuilder: (context, index) {
                                  final Recette = _filteredRecettes[index];
                                  final isFavorite = _favoriteIds.contains(Recette.id);

                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          Recette.image,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image, color: Colors.grey),
                                            );
                                          },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      title: Text(Recette.name),
                                      trailing: IconButton(
                                        icon: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: isFavorite ? Colors.red : null,
                                        ),
                                        onPressed: () => _toggleFavorite(Recette),
                                      ),
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DetailScreen(
                                              Recette: Recette,
                                              isFromFavorites: false,
                                              onFavoriteChanged: () {
                                                loadFavoriteIds();
                                                widget.onFavoriteChanged?.call();
                                              },
                                            ),
                                          ),
                                        );
                                        loadFavoriteIds();
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}