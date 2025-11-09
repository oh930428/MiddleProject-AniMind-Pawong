import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pet/domain/entities/pet.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;
    if (pet.imageUrl.startsWith('http')) {
      backgroundImage = NetworkImage(pet.imageUrl);
    } else if (pet.imageUrl.isNotEmpty) {
      backgroundImage = FileImage(File(pet.imageUrl));
    }

    return Container(
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
                '강아지 / ${pet.breed}',
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
