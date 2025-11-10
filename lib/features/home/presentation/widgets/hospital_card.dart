import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';

import '../../../../core/theme/app_colors.dart';

class HospitalCard extends StatelessWidget {
  final MedicalRecords record;

  const HospitalCard({super.key, required this.record});

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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          spacing: 10,
          children: [
            const Icon(Icons.local_hospital_outlined, color: AppColors.primary),
            Expanded(
              child: Column(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.visitReason,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    record.memo ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (record.nextVisitat != null && record.nextVisitat != null)
                    Text(
                      '다음 방문일: ${record.nextVisitat!.year}-${record.nextVisitat!.month.toString().padLeft(2, '0')}-${record.nextVisitat!.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              record.visitedat != null
                  ? "${record.visitedat!.year}-${record.visitedat!.month.toString().padLeft(2, '0')}-${record.visitedat!.day.toString().padLeft(2, '0')}"
                  : '',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
