import 'package:flutter/material.dart';
import '../../data/mock_catalog.dart';
import '../../data/models.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class HarnessWalkScreen extends StatelessWidget {
  const HarnessWalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = MockCatalog.harnessWalkRoutes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ship Tours'),
        backgroundColor: HlTokens.sea,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                const Text(
                  'Explore Aether of the Seas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Discover the ship with our guided walking routes. Perfect for your first day aboard!',
                  style: TextStyle(
                    color: HlTokens.inkSoft,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                ...routes.map((route) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RouteCard(route: route),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route});
  final HarnessWalkRoute route;

  @override
  Widget build(BuildContext context) {
    return HlCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: route.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  route.icon,
                  color: route.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${route.duration} · ${route.distance}',
                      style: const TextStyle(
                        color: HlTokens.inkSoft,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            route.description,
            style: const TextStyle(
              color: HlTokens.inkSoft,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: route.stops.map((stop) => SoftChip(stop)).toList(),
          ),
        ],
      ),
    );
  }
}
