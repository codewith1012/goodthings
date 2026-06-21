class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    image: 'assets/images/OnBoardingScreenImg-1.webp',
    title: 'Welcome to your sanctuary of joy.',
    description:
        'A dedicated space to capture the small moments that make life beautiful.',
  ),
  OnboardingModel(
    image: 'assets/images/OnBoardingScreenImg-2.webp',
    title: 'Cultivate a heart of gratitude.',
    description:
        'Daily reflection is proven to increase happiness and reduce stress. Let\'s start this journey together.',
  ),
  OnboardingModel(
    image: 'assets/logo/app_logo_foreground.png',
    title: 'Welcome,',
    description:
        "I am so glad you're here. Let's start capturing your first good thing.",
  ),
];
