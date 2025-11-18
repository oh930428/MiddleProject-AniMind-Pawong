import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/core/extensions/datetime_extensions.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_medical_records.dart';

class HomeMedicalCard extends StatelessWidget {
  final HomeMedicalRecords record;

  const HomeMedicalCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(Icons.local_hospital_outlined, color: AppColors.primary),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.visitReason,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '다음 방문일: ${"${record.visitedAt.year}-${record.visitedAt.month.toString().padLeft(2, '0')}-${record.visitedAt.day.toString().padLeft(2, '0')}"}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Text(
              record.visitedAt.getTimeAgo(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
