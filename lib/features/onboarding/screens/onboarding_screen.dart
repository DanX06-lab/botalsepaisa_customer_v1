import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/design_system.dart';
import '../../../shared/widgets/primary_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Recycle & Earn",
      "subtitle": "Scan your empty bottles, recycle them, and earn instant rewards in your wallet.",
      "icon": "recycling",
    },
    {
      "title": "Find Verified Shops",
      "subtitle": "Locate our partner shops easily and hand over your bottles to get paid.",
      "icon": "store",
    },
    {
      "title": "Save the Planet",
      "subtitle": "Every bottle you recycle helps protect the environment for future generations.",
      "icon": "public",
    },
  ];

  IconData _getIcon(String name) {
    switch (name) {
      case 'recycling':
        return Icons.recycling;
      case 'store':
        return Icons.storefront;
      case 'public':
        return Icons.public;
      default:
        return Icons.star;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIcon(_onboardingData[index]["icon"]!),
                          size: 150,
                          color: AppColors.primary,
                        ).animate().scale(delay: 200.ms, duration: 500.ms),
                        SizedBox(height: 48),
                        Text(
                          _onboardingData[index]["title"]!,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                        SizedBox(height: 16),
                        Text(
                          _onboardingData[index]["subtitle"]!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 32 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(
                    text: _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                    icon: _currentPage == _onboardingData.length - 1 ? Icons.arrow_forward : null,
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        context.go('/login');
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
