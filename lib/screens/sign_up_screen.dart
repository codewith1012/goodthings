import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodthings/providers/sharedprefs_provider.dart';
import 'package:goodthings/screens/onboarding_screen.dart';
import 'package:goodthings/services/auth_service.dart';
import 'package:goodthings/utils/popup_toast.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(name: _nameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            ..._buildBackgroundElements(),

            // 2. Main content canvas
            SafeArea(child: Center(child: _buildMainContent())),
          ],
        ),
      ),
    );
  }

  List<Positioned> _buildBackgroundElements() {
    return [
      Positioned.fill(child: Container(color: const Color(0xFFF8F9FF))),
      Positioned(
        top: -150,
        left: -150,
        width: 300,
        height: 400,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(24, 246, 114, 204),
          ),
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        right: -100,
        width: 350,
        height: 350,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(24, 246, 176, 101),
          ),
        ),
      ),
      Positioned(
        bottom: -100,
        left: 50,
        width: 450,
        height: 450,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(35, 255, 189, 241),
          ),
        ),
      ),
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: const SizedBox.shrink(),
        ),
      ),
    ];
  }

  SingleChildScrollView _buildMainContent() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildHeader(),
          const SizedBox(height: 32),
          _buildCard(),

          // Social/Alternative Divider
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: Color(0x4DCAC4D4), // 30% outline-variant
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontFamily: 'Judson',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7A7583).withAlpha(153), // 60%
                    letterSpacing: 0.05,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: Color(0x4DCAC4D4), // 30% outline-variant
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Footer Info
          const Text(
            'Already have an account?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Judson',
              fontSize: 16,
              color: Color(0xFF494552),
            ),
          ),
          GestureDetector(
            onTap: () async {
              bool isNew = await _authService.isNewUser();
              if (isNew) {
                if (mounted) {
                  showToast(context: context, message: "Sign Up Mate!!");
                }
                await _authService.deleteCurrentUser();
              } else {
                ref.read(localPrefsProvider).setOnBoardingCompleted();
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Judson',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(206, 255, 153, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHeader() {
    return [
      Text(
        'Reflect on Your Journey',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      const SizedBox(height: 8),
      Text(
        '❤️ Embrace Gratidude ❤️',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    ];
  }

  Padding _buildCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(195, 255, 255, 255),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0x66FFFFFF), // white 40%
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(120, 111, 69, 100),
                blurRadius: 60,
                offset: Offset(0, 20),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name Field
                _buildFieldLabel('Nick Name'),
                const SizedBox(height: 8),
                _buildNameField(),
                const SizedBox(height: 20),

                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildSubmitButton() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(32)),
        gradient: LinearGradient(
          colors: [Color(0xAAFFC107), Color(0xAAFF9800)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(72, 111, 69, 100),
            blurRadius: 14,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let\'s Goo',
              style: TextStyle(
                fontFamily: 'Judson',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Judson',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF494552),
          letterSpacing: 0.05,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0x66FFFFFF), // 40% white
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
        style: const TextStyle(
          fontFamily: 'Judson',
          fontSize: 16,
          color: Color(0xFF121C2A),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: const Color(0xFF7A7583),
            size: 20,
          ),
          hintText: "Sangita",
          hintStyle: const TextStyle(
            fontFamily: 'Judson',
            fontSize: 16,
            color: Color(0x807A7583), // 50%
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xAAFFC107), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
      ),
    );
  }
}
