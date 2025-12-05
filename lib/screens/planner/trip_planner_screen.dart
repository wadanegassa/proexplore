import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';
import '../../../../data/models/models.dart';
import 'widgets/create_trip_dialog.dart';
import 'widgets/trip_card.dart';
import '../../widgets/common/smart_image.dart';

class TripPlannerScreen extends StatelessWidget {
  const TripPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripProvider>();
    final theme = Theme.of(context);
    final now = DateTime.now();

    final ongoingTrips = provider.trips.where((t) => 
      t.startDate.isBefore(now) && t.endDate.isAfter(now)).toList();
    
    final upcomingTrips = provider.trips.where((t) => 
      t.startDate.isAfter(now)).toList();
    
    final pastTrips = provider.trips.where((t) => 
      t.endDate.isBefore(now)).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 220.0,
                floating: false,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
                  title: Text(
                    'My Trips',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 8.0,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      SmartImage(
                        imageUrl: 'assets/images/onboarding2.jpg',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  indicatorColor: const Color(0xFFFEDB00),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Ongoing'),
                    Tab(text: 'Past'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildTripList(context, upcomingTrips, 'No upcoming trips'),
              _buildTripList(context, ongoingTrips, 'No ongoing trips'),
              _buildTripList(context, pastTrips, 'No past trips'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateTripDialog(context, provider),
          backgroundColor: const Color(0xFF009639),
          icon: const Icon(Icons.add_location_alt),
          label: const Text('New Trip', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTripList(BuildContext context, List<Trip> trips, String emptyMessage) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF009639).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flight_takeoff,
                size: 80,
                color: const Color(0xFF009639).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start planning your adventure!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return TripCard(
          trip: trip,
          imageUrl: trip.destinationImageUrl ?? 'assets/images/onboarding3.jpg',
          onTap: () {
            // TODO: Navigate to trip details
          },
          onDelete: () {
            final provider = context.read<TripProvider>();
            provider.deleteTrip(trip.id);
          },
        );
      },
    );
  }

  Future<void> _showCreateTripDialog(BuildContext context, TripProvider provider) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateTripDialog(),
    );

    if (result != null) {
      provider.addTrip(
        result['name'] as String,
        result['startDate'] as DateTime,
        result['endDate'] as DateTime,
        destinationId: result['destinationId'] as String?,
        destinationName: result['destinationName'] as String?,
        destinationImageUrl: result['destinationImage'] as String?,
      );
    }
  }
}
