import 'package:flutter/material.dart';
import '../data/models/models.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

class DestinationsProvider extends ChangeNotifier {
  final DataService _dataService;
  final StorageService _storageService;

  List<Destination> _destinations = [];
  List<Destination> _filteredDestinations = [];
  List<String> _favoriteIds = [];
  bool _isLoading = false;

  DestinationsProvider(this._dataService, this._storageService) {
    loadData();
  }

  List<Destination> get destinations => _filteredDestinations;
  bool get isLoading => _isLoading;
  List<String> get favoriteIds => _favoriteIds;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _destinations = await _dataService.getDestinations();
      _filteredDestinations = List.from(_destinations);
      
      // Load favorites
      final savedFavs = _storageService.get(StorageService.favoritesBox, 'ids');
      if (savedFavs != null) {
        _favoriteIds = List<String>.from(savedFavs);
      }
    } catch (e) {
      debugPrint('Error loading destinations: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredDestinations = List.from(_destinations);
    } else {
      _filteredDestinations = _destinations.where((d) {
        return d.name.toLowerCase().contains(query.toLowerCase()) ||
               d.country.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    _storageService.put(StorageService.favoritesBox, 'ids', _favoriteIds);
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);
}
