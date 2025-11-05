import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/theme/app_colors.dart';

// 설정 화면 위젯
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('설정', style: theme.textTheme.headlineSmall),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: theme.colorScheme.outline.withOpacity(0.1),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppLayout.horizontalPadding),
        child: Column(
          children: [
            // ------------------------------------
            // 1. 반려인 정보 카드
            // ------------------------------------
            _buildSectionCard(
              theme,
              title: '반려인',
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    '반',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'user@kakao.com',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('카카오 로그인'),
              ),
            ),
            const SizedBox(height: AppLayout.sectionSpacing),

            // ------------------------------------
            // 2. 앱 정보 카드
            // ------------------------------------
            _buildSectionCard(
              theme,
              title: '앱 정보',
              child: Column(
                children: [
                  // 앱 버전
                  _buildSettingItem(title: '버전 1.0.0', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: AppLayout.sectionSpacing),

            // ------------------------------------
            // 3. 기능 카드 (로그아웃, 온보딩)
            // ------------------------------------
            _buildSectionCard(
              theme,
              child: Column(
                children: [
                  // 로그아웃
                  _buildSettingItem(
                    icon: Icons.logout,
                    title: '로그아웃',
                    subtitle: '다른 계정으로 로그인하기',
                    onTap: () {
                      // TODO: 로그아웃 기능 구현
                      _showActionSnackbar(context, '로그아웃 기능이 호출되었습니다.');
                    },
                  ),
                  Divider(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    height: 1,
                  ),

                  // 온보딩 다시 보기
                  _buildSettingItem(
                    icon: Icons.refresh,
                    title: '온보딩 다시 보기',
                    subtitle: '앱 소개를 다시 확인합니다',
                    isLast: true,
                    onTap: () {
                      // TODO: 온보딩 화면으로 이동
                      _showActionSnackbar(context, '온보딩 재시작 기능이 호출되었습니다.');
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

  // 흰색 배경의 섹션 카드를 만드는 헬퍼 함수
  Widget _buildSectionCard(
    ThemeData theme, {
    required Widget child,
    String? title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppLayout.cardRadius),
            boxShadow: AppElevation.cardShadow,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: title != null
                ? AppLayout.horizontalPadding
                : 0, // 제목이 있으면 패딩 적용
            vertical:
                AppLayout.verticalPadding /
                (title != null ? 1 : 2), // 제목 유무에 따라 상하 패딩 조절
          ),
          child: child,
        ),
      ],
    );
  }

  // 설정 항목 ListTile을 만드는 헬퍼 함수
  Widget _buildSettingItem({
    IconData? icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: subtitle != null ? 8.0 : 16.0,
          horizontal: AppLayout.horizontalPadding,
        ),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(icon, color: AppColors.textSecondary),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: subtitle != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  // 임시 액션 스낵바
  void _showActionSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
