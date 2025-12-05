import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/destinations_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _isSatellite = false;

  // Map tile URLs
  final String _streetMapUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  final String _satelliteMapUrl = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  void _toggleMapType() {
    setState(() {
      _isSatellite = !_isSatellite;
    });
  }

  void _centerOnEthiopia() {
    _mapController.move(const LatLng(9.0320, 38.7469), 5.5);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DestinationsProvider>();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(9.0320, 38.7469), // Addis Ababa
              initialZoom: 5.5,
              minZoom: 4.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite ? _satelliteMapUrl : _streetMapUrl,
                userAgentPackageName: 'com.example.protravel',
                tileProvider: NetworkTileProvider(),
              ),
              // Labels layer for satellite view
              if (_isSatellite)
                TileLayer(
                  urlTemplate: 'https://stamen-tiles.a.ssl.fastly.net/toner-labels/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.protravel',
                ),
              MarkerLayer(
                markers: provider.destinations.map((dest) {
                  return Marker(
                    point: LatLng(dest.latitude, dest.longitude),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF009639),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.location_on, color: Colors.white),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dest.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            dest.country,
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEDB00),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star, size: 16, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            dest.rating.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  dest.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(height: 1.5, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.push('/destination/${dest.id}');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF009639),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('View Details'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF009639),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.location_on, color: Colors.white, size: 28),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Ethiopian flag accent at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF009639),
                    Color(0xFFFEDB00),
                    Color(0xFFDA121A),
                  ],
                ),
              ),
            ),
          ),
          // Map controls
          Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              children: [
                // Zoom in
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom + 1,
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Color(0xFF009639)),
                ),
                const SizedBox(height: 8),
                // Zoom out
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom - 1,
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Color(0xFF009639)),
                ),
                const SizedBox(height: 12),
                // Center on Ethiopia
                FloatingActionButton(
                  heroTag: 'location',
                  onPressed: _centerOnEthiopia,
                  backgroundColor: Colors.white,
                  tooltip: 'Center on Ethiopia',
                  child: const Icon(Icons.my_location, color: Color(0xFF009639)),
                ),
                const SizedBox(height: 12),
                // Toggle satellite/street view
                FloatingActionButton(
                  heroTag: 'layers',
                  onPressed: _toggleMapType,
                  backgroundColor: _isSatellite ? const Color(0xFF009639) : Colors.white,
                  tooltip: _isSatellite ? 'Street View' : 'Satellite View',
                  child: Icon(
                    _isSatellite ? Icons.map : Icons.satellite,
                    color: _isSatellite ? Colors.white : const Color(0xFF009639),
                  ),
                ),
              ],
            ),
          ),
          // Map type indicator
          Positioned(
            top: 16,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isSatellite ? Icons.satellite : Icons.map,
                    size: 16,
                    color: const Color(0xFF009639),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isSatellite ? 'Satellite' : 'Street',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF009639),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
