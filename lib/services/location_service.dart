class LocationService {
  // Mock location for Tokyo
  Future<Map<String, double>> getCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    return {'latitude': 35.6762, 'longitude': 139.6503};
  }
}
