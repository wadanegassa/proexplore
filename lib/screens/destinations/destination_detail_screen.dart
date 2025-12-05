import '../../widgets/common/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/destinations_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../planner/widgets/create_trip_dialog.dart';

class DestinationDetailScreen extends StatelessWidget {
  final String id;

  const DestinationDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DestinationsProvider>();
    final destination = provider.destinations.firstWhere(
      (d) => d.id == id,
      orElse: () => provider.destinations.first,
    );
    final isFavorite = provider.isFavorite(id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'destination-$id',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SmartImage(
                      imageUrl: destination.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFFDA121A) : Colors.grey[800],
                  ),
                  onPressed: () => provider.toggleFavorite(id),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination.name,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 20, color: Color(0xFF009639)),
                                  const SizedBox(width: 4),
                                  Text(
                                    destination.country,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEDB00),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.white, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                destination.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Categories
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: destination.categories.map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF009639).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF009639)),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Color(0xFF009639),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      destination.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    if (destination.images.length > 1) ...[
                      Text(
                        'Gallery',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: destination.images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SmartImage(
                                  imageUrl: destination.images[index],
                                  width: 240,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    
                    PrimaryButton(
                      text: 'Add to Trip',
                      onPressed: () async {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (context) => CreateTripDialog(initialDestination: destination),
                        );

                        if (result != null && context.mounted) {
                          final tripProvider = context.read<TripProvider>();
                          tripProvider.addTrip(
                            result['name'] as String,
                            result['startDate'] as DateTime,
                            result['endDate'] as DateTime,
                            destinationId: result['destinationId'] as String?,
                            destinationName: result['destinationName'] as String?,
                            destinationImageUrl: result['destinationImage'] as String?,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${destination.name} added to your trips'),
                              backgroundColor: const Color(0xFF009639),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
