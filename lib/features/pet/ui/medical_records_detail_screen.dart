import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';

class MedicalRecordsDetailScreen extends StatelessWidget {
  final MedicalRecords record;

  const MedicalRecordsDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('병원 기록 상세')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('방문 이유', record.visitReason),
            _buildDetailRow(
              '방문 날짜',
              DateFormat('yyyy-MM-dd').format(record.visitedat!),
            ),
            _buildDetailRow('다음 방문 예정일 (선택)', record.nextVisitat as String?),
            _buildDetailRow('메모', record.memo),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(value ?? '정보 없음', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
