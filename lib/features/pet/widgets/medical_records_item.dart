import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';

// 병원 기록 항목을 보여주는 위젯
class MedicalRecordsItem extends StatelessWidget {
  final MedicalRecords record;

  const MedicalRecordsItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: const Icon(
          Icons.local_hospital_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          record.visitReason,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '방문일: ${record.visitedat != null ? DateFormat('yyyy-MM-dd').format(record.visitedat!) : '날짜 미상'}',
            ),
            Text('메모: ${record.memo}'),
            if (record.nextVisitat != null)
              Text(
                '다음 방문일: ${DateFormat('yyyy-MM-dd').format(record.nextVisitat!)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: null,
      ),
    );
  }
}
