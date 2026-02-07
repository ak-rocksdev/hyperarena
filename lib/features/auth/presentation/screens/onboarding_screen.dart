import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });
}

const _pages = [
  _OnboardingPage(
    icon: Icons.sports_tennis,
    title: 'Cari & Booking Lapangan',
    subtitle: 'Temukan dan booking lapangan olahraga favoritmu dengan mudah dan cepat',
    iconColor: AppColors.primary,
  ),
  _OnboardingPage(
    icon: Icons.school,
    title: 'Temukan Coach Terbaik',
    subtitle: 'Belajar dari coach profesional untuk meningkatkan skill olahragamu',
    iconColor: AppColors.secondary,
  ),
  _OnboardingPage(
    icon: Icons.trending_up,
    title: 'Lacak Perkembangan',
    subtitle: 'Pantau progress, kumpulkan XP, dan naik level setiap kali bermain',
    iconColor: AppColors.accent,
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  void _complete() {
    ref.read(sharedPreferencesProvider).setBool('onboarding_complete', true);
    context.go('/auth/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _complete,
                child: const Text('Lewati'),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with circle background + shadow
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.md,
                          ),
                          child: Icon(
                            page.icon,
                            size: 64,
                            color: page.iconColor,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xxl),
                        Text(
                          page.title,
                          style: AppTypography.headingLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          page.subtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) {
                  final isActive = _currentPage == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 28 : 8,
                    height: isActive ? 10 : 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.neutral300,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull),
                      boxShadow: isActive ? AppShadows.xs : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Bottom button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenHorizontal,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: isLast ? 'Mulai' : 'Selanjutnya',
                  isLarge: true,
                  onPressed: () {
                    if (isLast) {
                      _complete();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.screenBottom),
          ],
        ),
      ),
    );
  }
}
