import 'dart:io';

import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/home/domain/entities/home_pet.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pet/domain/entities/pet.dart';

class PetCard extends StatelessWidget {
  final HomePet pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;

    final imageUrl = pet.imageUrl;

    if (imageUrl != null && imageUrl.startsWith('http')) {
      backgroundImage = NetworkImage(imageUrl);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      backgroundImage = FileImage(File(imageUrl));
    }

    return Container(
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.lightGrey,
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
                pet.petName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${pet.speciesName} / ${pet.breedsName}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
