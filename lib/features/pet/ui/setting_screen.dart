import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';
import 'package:middleproject_animind_pawong/features/auth/domain/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../domain/viewmodel/setting_viewmodel.dart';

// 설정 화면 위젯
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingViewModel(),
      child: const _SettingsScreenView(),
    );
  }
}

class _SettingsScreenView extends StatefulWidget {
  const _SettingsScreenView({super.key});

  @override
  State<_SettingsScreenView> createState() => _SettingsScreenViewState();
}

class _SettingsScreenViewState extends State<_SettingsScreenView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingViewModel>(context, listen: false).loadUserEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingViewModel = Provider.of<SettingViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userEmail = settingViewModel.userEmail;

    return Scaffold(
      appBar: AppBar(
        title: Text('설정', style: theme.textTheme.headlineSmall),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ------------------------------------
            // 1. 반려인 정보 카드
            // ------------------------------------
            _buildSectionCard(
              theme,
              title: '반려인',
              child: settingViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryContainer,
                        child: Text(
                          userEmail?.isNotEmpty == true
                              ? userEmail![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        userEmail ?? '이메일을 불러오지 못했습니다.',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('구글 로그인'),
                    ),
            ),
            const SizedBox(height: 24.0),

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
            const SizedBox(height: 24.0),

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
                    onTap: () async {
                      await authViewModel.logOut();
                      if (mounted) {
                        context.go('/');
                      }
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

  void _showActionSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
