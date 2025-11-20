import 'dart:io';

import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';

// 반려동물의 기본 정보를 보여주는 카드 위젯
class ProfileCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ProfileCard({
    super.key,
    required this.pet,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  IconData _getIconForItem(Map<String, String> item) {
    final label = item['label']!;
    final value = item['value']!;

    switch (label) {
      case '종':
        return Icons.category;
      case '품종':
        return Icons.pets;
      case '나이':
        return Icons.cake;
      case '성별':
        if (value == '여아') return Icons.female;
        return Icons.male;
      case '생일':
        return Icons.calendar_today;
      case '체중':
        return Icons.monitor_weight;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 이미지 소스 결정 (네트워크 또는 로컬 파일)
    ImageProvider? backgroundImage;
    if (pet.imageUrl!.startsWith('http')) {
      backgroundImage = NetworkImage(pet.imageUrl!);
    } else if (pet.imageUrl!.isNotEmpty) {
      backgroundImage = FileImage(File(pet.imageUrl!));
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding * 1.5,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.lightGrey,
                      backgroundImage: backgroundImage,
                      child: backgroundImage == null
                          ? const Icon(Icons.pets, size: 40, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: pet.infoGridData.length,
                itemBuilder: (context, index) {
                  final item = pet.infoGridData[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getIconForItem(item),
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item['label']!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['value']!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton<String>(
              constraints: const BoxConstraints(maxWidth: 80),
              onSelected: (value) {
                if (value == 'edit') {
                  onEditPressed();
                } else if (value == 'delete') {
                  onDeletePressed();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16.0),
                      SizedBox(width: 8),
                      Text('수정', style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 16.0,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '삭제',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
