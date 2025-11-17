import 'package:flutter/material.dart';

// --------------------------------------------------------------------------
// 1. 색상 토큰 (청록색 계열로 변경 예정)
// --------------------------------------------------------------------------

class AppColors {
  // Light Mode Colors (default)
  static const Color primary = Color(0xFF359B73); // 청록색 계열
  static const Color primaryContainer = Color(0xFFE5F2EE); // 청록색 연한 배경
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFE5E5E5);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color background = Color(0xFFF7F8FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color danger = Color(0xFFFF4D4F);

  // Dark Mode Adjustments (Tone adjustments for dark surface)
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkBackground = Color(0xFF1F1F1F);
  static const Color darkTextPrimary = Color(0xFFEBEBEB);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkBorder = Color(0xFF333333);
}

// --------------------------------------------------------------------------
// 2. 타이포그래피 토큰 (Typography Tokens) - 기본 시스템 폰트 사용
// --------------------------------------------------------------------------

class AppTextStyles {
  // Title/Screen: 20–22, w600–700 (Headline Small/Title Large)
  static const TextStyle screenTitle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    height: 1.2, // Line height for better readability
  );

  // Section: 16–18, w600 (Title Medium/Title Large)
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Body: 14–16, w400 (Body Medium/Body Large)
  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Caption/Label: 12–13, w400–500 (Label Small/Label Medium)
  static const TextStyle label = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Button: 15–16, w500–600
  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );
}

// --------------------------------------------------------------------------
// 3. 레이아웃/간격 토큰 (Layout/Spacing Tokens)
// --------------------------------------------------------------------------

class AppLayout {
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double elementSpacing = 12.0;
  static const double iconTextSpacing = 8.0;
  static const double cardRadius = 16.0;
  static const double minTouchTarget = 48.0;
}

// --------------------------------------------------------------------------
// 4. 기타 토큰 (Shadow, etc.)
// --------------------------------------------------------------------------

class AppElevation {
  // 매우 약한 그림자 (Soft/Subtle Shadow for cards)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x05000000), // Very slight black
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}
