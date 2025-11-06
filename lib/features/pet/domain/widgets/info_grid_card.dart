import 'package:flutter/material.dart';

import '../ui/utils.dart';

// 반려동물의 상세 정보를 그리드 형태로 보여주는 카드 위젯
class InfoGridCard extends StatelessWidget {
  final List<Map<String, String>> data;

  const InfoGridCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PetColors.cardBackground,
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        border: Border.all(color: PetColors.border, width: 1),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['label']!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: PetColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                item['value']!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}
