import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/models/models.dart';
import '../services/storage_service.dart';

class TripProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<Trip> _trips = [];

  TripProvider(this._storageService) {
    _loadTrips();
  }

  List<Trip> get trips => _trips;

  void _loadTrips() {
    final data = _storageService.get(StorageService.tripsBox, 'trips');
    if (data is List) {
      _trips = data
          .whereType<Map>()
          .map((e) => Trip.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      _trips = [];
    }
  }

  void addTrip(String name, DateTime start, DateTime end, {String? destinationId, String? destinationName, String? destinationImageUrl}) {
    final newTrip = Trip(
      id: const Uuid().v4(),
      name: name,
      startDate: start,
      endDate: end,
      destinationId: destinationId,
      destinationName: destinationName,
      destinationImageUrl: destinationImageUrl,
    );
    _trips.add(newTrip);
    _storageService.put(
      StorageService.tripsBox,
      'trips',
      _trips.map((t) => t.toJson()).toList(),
    );
    notifyListeners();
  }

  void deleteTrip(String id) {
    _trips.removeWhere((t) => t.id == id);
    _storageService.put(
      StorageService.tripsBox,
      'trips',
      _trips.map((t) => t.toJson()).toList(),
    );
    notifyListeners();
  }
}
