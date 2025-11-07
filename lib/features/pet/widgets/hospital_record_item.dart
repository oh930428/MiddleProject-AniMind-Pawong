import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/pet_data.dart';

// 병원 기록 항목을 보여주는 위젯
class HospitalRecordItem extends StatelessWidget {
  final HospitalRecord record;

  const HospitalRecordItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        side: const BorderSide(color: PetColors.border, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: AppLayout.elementSpacing),
      child: ListTile(
        leading: const Icon(
          Icons.local_hospital_outlined,
          color: PetColors.primary,
        ),
        title: Text(
          record.visitReason,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.memo),
            if (record.nextVisitDate != null &&
                record.nextVisitDate!.isNotEmpty)
              Text(
                '다음 방문: ${record.nextVisitDate}',
                style: TextStyle(
                  color: PetColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        trailing: Text(
          record.visitDate,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
