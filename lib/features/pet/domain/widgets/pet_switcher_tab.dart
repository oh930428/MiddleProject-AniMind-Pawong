import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/utils.dart';

import '../entities/pet_data.dart';

// 여러 반려동물을 탭 형태로 전환하며 보여주는 위젯
class PetSwitcherTab extends StatelessWidget {
  final List<Pet> pets;
  final Pet selectedPet;
  final ValueChanged<Pet> onPetSelected;
  final VoidCallback onAddPet;

  const PetSwitcherTab({
    super.key,
    required this.pets,
    required this.selectedPet,
    required this.onPetSelected,
    required this.onAddPet,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...pets.map((pet) {
                final isSelected = pet.id == selectedPet.id;
                return GestureDetector(
                  onTap: () => onPetSelected(pet),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PetColors.primary
                          : Colors.transparent,
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
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: onAddPet,
                tooltip: '반려동물 추가',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
