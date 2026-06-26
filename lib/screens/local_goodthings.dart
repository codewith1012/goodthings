import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/goodthing_model.dart';
import 'package:goodthings/providers/cardlist_provider.dart';
import 'package:goodthings/providers/user_provider.dart';
import 'package:goodthings/screens/profile_screen.dart';
import 'package:goodthings/widgets/goodthing_card.dart';

const _tertiaryContainer = Color(0xFFFFAA4E);
const _onTertiaryContainer = Color(0xFF704000);
const _primaryFixed = Color(0xFFFFD9E0);
const _onSurfaceVariant = Color(0xFF524346);

class LocalGoodthings extends ConsumerWidget {
  const LocalGoodthings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<GoodthingModel> goodThings = ref.watch(cardListProvider);
    final User? user = ref.watch(userProvider);

    return Stack(
      children: [
        _buildBackGroundEffects(),
        _buildContent(context, user, goodThings),
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

  Positioned _buildContent(
    BuildContext context,
    User? user,
    List<GoodthingModel> goodThings,
  ) {
    return Positioned.fill(
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                minHeight: 76,
                maxHeight: 76,
                child: _buildTopBar(context, user!),
              ),
            ),

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
                          padding: const EdgeInsets.only(bottom: 18),
                          child: GoodthingCard(cardData: goodThings[index]),
                        ),
                        childCount: goodThings.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              color: Color(0xFF894C5C),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Waiting for your first\nGood Thing!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Judson',
              fontSize: 20,
              color: Color(0xFF894C5C),
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

  Widget _buildTopBar(BuildContext context, User user) {
    String greetingMessage = _decideGreetingMessage();

    return Container(
      color: const Color(0xFFFFF8F7).withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  '$greetingMessage ${user.displayName}',
                  style: TextStyle(
                    fontFamily: 'Judson',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    letterSpacing: -0.3,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),

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
              _buildAvatar(context, user),
            ],
          ),
        ],
      ),
    );
  }

  String _decideGreetingMessage() {
    int hour = DateTime.now().hour;

    if (hour >= 4 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 16) {
      return "Good AfterNoon";
    } else if (hour >= 16 && hour < 21) {
      return "Good Evening";
    }

    return "Have a Sleep,";
  }

  GestureDetector _buildAvatar(BuildContext context, User user) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _primaryFixed,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.photoURL!,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}

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
