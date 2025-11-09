import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pet/domain/entities/pet.dart';

class PetSwitcherTab extends StatelessWidget {
  final List<Pet> pets;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const PetSwitcherTab({
    super.key,
    required this.pets,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...pets.asMap().entries.map((entry) {
            final index = entry.key;
            final pet = entry.value;
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () => onSelect(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  pet.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),

          IconButton(icon: const Icon(Icons.add, size: 20), onPressed: () {}),
        ],
      ),
    );
  }
}
