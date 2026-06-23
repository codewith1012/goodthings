import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';
import 'package:goodthings/widgets/goodthing_card.dart';

const _primary = Color(0xFF894C5C);
const _tertiaryContainer = Color(0xFFFFAA4E);
const _onTertiaryContainer = Color(0xFF704000);
const _primaryFixed = Color(0xFFFFD9E0);
const _primaryContainer = Color(0xFFF4A7B9);
const _onSurfaceVariant = Color(0xFF524346);

class LocalGoodthings extends ConsumerWidget {
  const LocalGoodthings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<GoodthingModel> goodThings = ref.watch(cardListProvider);

    return Stack(
      children: [
        _buildBackGroundEffects(),
        // ── Main scrollable content ──────────────────────────────────────────
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Sticky top app bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    minHeight: 76,
                    maxHeight: 76,
                    child: _buildTopBar(),
                  ),
                ),

                // Cards feed
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                  sliver: goodThings.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GoodthingCard(cardData: goodThings[index]),
                            ),
                            childCount: goodThings.length,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Positioned _buildBackGroundEffects() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.8,
            colors: [Color(0xFFFFF8F7), Color(0xFFFDF1F2), Color(0xFFF7EBEC)],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  static Widget _buildTopBar() {
    return Container(
      color: const Color(0xFFFFF8F7).withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Your Spark of Joy',
                  style: TextStyle(
                    fontFamily: 'Judson',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                    letterSpacing: -0.3,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Good things you\'ve noticed ✨',
                  style: TextStyle(
                    fontFamily: 'Judson',
                    fontSize: 13,
                    color: _onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Right: streak badge beside avatar in a Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Streak badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _tertiaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: _onTertiaryContainer,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '14',
                      style: TextStyle(
                        fontFamily: 'Judson',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primaryFixed,
                  shape: BoxShape.circle,
                  border: Border.all(color: _primaryContainer, width: 2),
                ),
                child: const ClipOval(
                  child: Icon(Icons.person_rounded, color: _primary, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────
  static Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 34,
              color: _primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Waiting for your first\nGood Thing!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Judson',
              fontSize: 20,
              color: _primary,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to capture\nsomething that made you smile.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Judson',
              fontSize: 14,
              color: _onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sliver persistent header helper ────────────────────────────────────────────
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  const _StickyHeaderDelegate({
    required this.child,
    this.minHeight = 76,
    this.maxHeight = 76,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) =>
      old.child != child ||
      old.minHeight != minHeight ||
      old.maxHeight != maxHeight;
}
