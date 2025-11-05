// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

// 기본 폰트 패밀리 (시스템 기본 or Noto Sans KR fallback)
const String _kDefaultFontFamily = 'Noto Sans KR';

class AppTheme {
  // 라이트 모드 테마
  static ThemeData get lightTheme {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.cardBackground,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.primary, // 보조 색상도 primary 계열 사용
      onSecondary: AppColors.cardBackground,
      error: AppColors.danger,
      onError: AppColors.cardBackground,
      background: AppColors.background,
      onBackground: AppColors.textPrimary,
      surface: AppColors.cardBackground,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
      surfaceContainer: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _kDefaultFontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: _buildTextTheme(
        colorScheme.onSurface,
        colorScheme.onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        surfaceTintColor: colorScheme.background,
        elevation: 0,
        titleTextStyle: AppTextStyles.screenTitle.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      // cardTheme: CardTheme(
      //   color: colorScheme.surface,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppLayout.cardRadius),
      //     side: const BorderSide(color: AppColors.border, width: 1),
      //   ),
      // ),
      // 최소 터치 영역 48x48을 위한 설정 (대부분의 위젯에 영향을 줌)
      materialTapTargetSize: MaterialTapTargetSize.padded,
      // 접근성 강화를 위한 IconTheme
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconSize: MaterialStateProperty.all(24.0),
          minimumSize: MaterialStateProperty.all(
            const Size(AppLayout.minTouchTarget, AppLayout.minTouchTarget),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        ),
      ),
    );
  }

  // 다크 모드 테마
  static ThemeData get darkTheme {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary, // Primary color kept
      onPrimary: AppColors.darkSurface,
      primaryContainer: AppColors
          .primary, // Use primary for container in dark mode for contrast
      onPrimaryContainer: AppColors.darkTextPrimary,
      secondary: AppColors.primary,
      onSecondary: AppColors.darkSurface,
      error: AppColors.danger,
      onError: AppColors.darkSurface,
      background: AppColors.darkBackground,
      onBackground: AppColors.darkTextPrimary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      outline: AppColors.darkBorder,
      surfaceContainer: AppColors.darkBackground,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _kDefaultFontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: _buildTextTheme(
        colorScheme.onSurface,
        colorScheme.onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        surfaceTintColor: colorScheme.background,
        elevation: 0,
        titleTextStyle: AppTextStyles.screenTitle.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      // cardTheme: CardTheme(
      //   color: colorScheme.surface,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppLayout.cardRadius),
      //     side: BorderSide(color: colorScheme.outline, width: 1),
      //   ),
      // ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconSize: MaterialStateProperty.all(24.0),
          minimumSize: MaterialStateProperty.all(
            const Size(AppLayout.minTouchTarget, AppLayout.minTouchTarget),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        ),
      ),
    );
  }

  // 텍스트 테마 구성
  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      // Screen Title (22px, w700)
      headlineSmall: AppTextStyles.screenTitle.copyWith(color: primaryColor),
      // Section Header (18px, w600)
      titleLarge: AppTextStyles.sectionHeader.copyWith(color: primaryColor),
      // Body (16px, w400)
      bodyLarge: AppTextStyles.body.copyWith(color: primaryColor),
      // Secondary/Caption Text (13px, w500)
      labelMedium: AppTextStyles.label.copyWith(color: secondaryColor),
      // Button Text (16px, w600)
      labelLarge: AppTextStyles.button.copyWith(color: primaryColor),
    );
  }
}
