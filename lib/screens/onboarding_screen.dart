import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/models/onboardscreen_model.dart';
import 'package:goodthings/providers/sharedprefs_provider.dart';
import 'package:goodthings/services/auth_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final String name;

  const OnboardingScreen({super.key, required this.name});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final AuthService authService = AuthService();

  @override
  void dispose() {
    _pageController.dispose(); // Always clear memory!
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ..._buildBackgroundEffects(),
          SafeArea(
            child: Column(
              children: [_buildBasicStructureOfPage(), _buildDotsAndButton()],
            ),
          ),
        ],
      ),
    );
  }

  List<Positioned> _buildBackgroundEffects() {
    return [
      Positioned.fill(child: Container(color: const Color(0xFFFFF8F7))),
      Positioned(
        top: -100,
        left: -100,
        width: 400,
        height: 400,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x22F4A7B9), // Soft primary-container
          ),
        ),
      ),
      Positioned(
        bottom: -100,
        right: -100,
        width: 450,
        height: 450,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x11FFAA4E), // Soft tertiary-container
          ),
        ),
      ),
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: const SizedBox.shrink(),
        ),
      ),
    ];
  }

  Expanded _buildBasicStructureOfPage() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: onboardingPages.length,
        itemBuilder: (context, index) {
          final page = onboardingPages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image Frame
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: AspectRatio(
                    aspectRatio: 1.0 / 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(page.image, fit: BoxFit.cover),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Content Title
                Text(
                  index == onboardingPages.length - 1
                      ? "${page.title} ${widget.name}"
                      : page.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Junge',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF894C5C), // Elegant primary brand color
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),

                // Content Description
                Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Judson',
                    fontSize: 16,
                    color: Color(0xFF524346),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding _buildDotsAndButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        children: [
          if (_currentPage == onboardingPages.length - 1) ...[
            _buildGoogleSignIn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Text(
                'By clicking Create Account, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Judson',
                  fontSize: 11,
                  color: const Color(0xFF7A7583).withAlpha(178), // 70%
                  height: 1.4,
                ),
              ),
            ),
          ] else ...[
            _buildDotScrollIndicator(),
            const SizedBox(height: 32),
            _buildActionButton(),
          ],
        ],
      ),
    );
  }

  SizedBox _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _nextPage,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6C8E), // Soft secondary accent
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
              shadowColor: const Color(0xFFF4A7B9),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return const Color.fromARGB(71, 244, 167, 185);
                }
                return null;
              }),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentPage == onboardingPages.length - 1 ? "Let's Go" : "Next",
              style: const TextStyle(
                fontFamily: 'Judson',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Row _buildDotScrollIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingPages.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color(0xFF8B5000) // Active tertiary color
                : const Color(0xFFD6C1C5), // Inactive outline-variant
          ),
        ),
      ),
    );
  }

  Padding _buildGoogleSignIn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF6C8E),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9999)),
          ),
          elevation: 5,
        ),
        onPressed: () async {
          await authService.signInWithGoogle(userName: widget.name);
          await ref.read(localPrefsProvider).setOnBoardingCompleted();
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(size: const Size(24, 24), painter: GoogleLogoPainter()),
            const SizedBox(width: 12),
            const Text(
              "Continue with Google",
              style: TextStyle(
                fontFamily: 'Judson',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, size.height / 2);
    final double thickness = radius * 0.40;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..isAntiAlias = true;

    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius - (thickness / 2),
    );

    // ==========================================
    // THE MATHEMATHICAL CORRECTION (Angles in Radians)
    // ==========================================

    // 1. 🔴 RED SECTOR (Top Arc)
    // Starts at top-right (-1.27 radians / -73°) and sweeps around to the left
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -math.pi * 0.40, -math.pi * 0.73, false, paint);

    // 2. 🟡 YELLOW SECTOR (Left Arc)
    // Picks up from Red (-2.01 radians / -115°) and sweeps down past the left side
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -math.pi * 1.13, -math.pi * 0.28, false, paint);

    // 3. 🟢 GREEN SECTOR (Bottom Arc)
    // Picks up from Yellow (-2.5 radians / -143°) and sweeps across the bottom
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, -math.pi * 1.41, -math.pi * 0.65, false, paint);

    // 4. 🔵 BLUE SECTOR (Right bottom hook meeting the stem)
    // Starts at the bottom-right and hooks up smoothly to the center line
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, math.pi * 0.05, math.pi * 0.17, false, paint);

    // 5. 🔵 BLUE HORIZONTAL STEM (The inner middle crossbar)
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Starts perfectly from the center axis line and steps directly to the right edge
    final Rect barRect = Rect.fromLTWH(
      center.dx,
      center.dy - (thickness / 2),
      radius,
      thickness,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
