import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/pet_data.dart';

// 반려동물의 기본 정보를 보여주는 카드 위젯
class ProfileCard extends StatelessWidget {
  final Pet pet;

  const ProfileCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    // 이미지 소스 결정 (네트워크 또는 로컬 파일)
    ImageProvider? backgroundImage;
    if (pet.imageUrl.startsWith('http')) {
      backgroundImage = NetworkImage(pet.imageUrl);
    } else if (pet.imageUrl.isNotEmpty) {
      backgroundImage = FileImage(File(pet.imageUrl));
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PetColors.cardBackground,
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: PetColors.lightGrey,
            backgroundImage: backgroundImage,
            child: backgroundImage == null
                ? const Icon(Icons.pets, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${pet.species} / ${pet.breed}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: PetColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
