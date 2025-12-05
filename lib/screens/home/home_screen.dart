import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/destinations_provider.dart';
import '../../widgets/cards/destination_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/smart_image.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DestinationsProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              expandedTitleScale: 1.5,
              title: Text(
                'Discover Ethiopia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 4.0,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  SmartImage(
                    imageUrl: 'assets/images/homescreen.jpeg',
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
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                  // Ethiopian flag colors accent
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
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
                ],
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => context.go('/explore'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => context.push('/settings'),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore the Land of Origins',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '13 months of sunshine awaits you 🇪🇹',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Must-Visit Destinations',
                  onSeeAll: () => context.go('/explore'),
                ),
                SizedBox(
                  height: 360,
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.destinations.length,
                          itemBuilder: (context, index) {
                            final dest = provider.destinations[index];
                            return DestinationCard(
                              destination: dest,
                              onTap: () => context.push('/destination/${dest.id}'),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 32),
                // Quick actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Access',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _QuickActionCard(
                            icon: Icons.translate,
                            title: 'Phrasebook',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF009639), Color(0xFF00B248)],
                            ),
                            onTap: () => context.push('/phrasebook'),
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _QuickActionCard(
                            icon: Icons.book,
                            title: 'Travel Guides',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFEDB00), Color(0xFFFFE54C)],
                            ),
                            onTap: () => context.push('/guides'),
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _QuickActionCard(
                            icon: Icons.map,
                            title: 'Explore Map',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0288D1), Color(0xFF03A9F4)],
                            ),
                            onTap: () => context.go('/map'),
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _QuickActionCard(
                            icon: Icons.currency_exchange,
                            title: 'Currency',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDA121A), Color(0xFFE91E63)],
                            ),
                            onTap: () => context.push('/tools'),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
