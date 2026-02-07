import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/theme/app_theme.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';

/// Dark ThemeData builder.
/// Reference: DESIGN_SYSTEM.md Section 1.13
extension AppThemeDark on AppTheme {
  static ThemeData dark() {
    final light = AppTheme.light();

    return light.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppSurfaces.darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        tertiary: AppColors.accent,
        onTertiary: AppColors.textOnAccent,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppSurfaces.darkSurface,
        onSurface: Color(0xFFF1F5F9), // textPrimary dark
        surfaceContainerHighest: AppSurfaces.darkSurfaceVariant,
        outline: Color(0xFF334155), // border dark
        outlineVariant: Color(0xFF1E293B), // borderLight dark
      ),

      // AppBar
      appBarTheme: light.appBarTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
        titleTextStyle: AppTypography.headingMedium.copyWith(
          color: const Color(0xFFF1F5F9),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF1F5F9)),
      ),

      // Navigation Bar
      navigationBarTheme: light.navigationBarTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
        indicatorColor: AppColors.primary900,
      ),

      // Cards
      cardTheme: light.cardTheme.copyWith(
        color: AppSurfaces.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),

      // Input
      inputDecorationTheme: light.inputDecorationTheme.copyWith(
        fillColor: AppSurfaces.darkSurfaceVariant,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 2),
        ),
      ),

      // Dialog
      dialogTheme: light.dialogTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
      ),

      // Bottom Sheet
      bottomSheetTheme: light.bottomSheetTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155),
        thickness: AppDimensions.dividerThickness,
        space: 0,
      ),

      // Tooltip
      tooltipTheme: light.tooltipTheme.copyWith(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.neutral900,
        ),
      ),

      // Extensions — same as light (brand colors don't change in dark mode)
      extensions: const [
        SportThemeExtension(),
        BookingStatusThemeExtension(),
        GamificationThemeExtension(),
        RatingThemeExtension(),
      ],
    );
  }
}
