import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 8),

        // 필터칩 리스트
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final label = options[index];
              final isSelected = label == selectedValue;

              return ActionChip(
                label: Text(
                  label == "post" ? "게시글" : label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => onSelected(label),
                color: WidgetStatePropertyAll(
                  isSelected ? AppColors.primary : AppColors.primaryContainer,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
