import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/entities/medical_records.dart';

class MedicalRecordsDetailScreen extends StatelessWidget {
  final MedicalRecords record;

  const MedicalRecordsDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('병원 기록 상세')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxCardWidth = constraints.maxWidth > 600
              ? 520.0
              : constraints.maxWidth * 0.92;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxCardWidth),
                child: Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '병원 방문 정보',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildDetailRow(
                          label: '방문 날짜',
                          value: record.visitedat != null
                              ? DateFormat(
                                  'yyyy-MM-dd',
                                ).format(record.visitedat!)
                              : '날짜 미상',
                        ),
                        const SizedBox(height: 12),

                        _buildDetailRow(
                          label: '다음 방문 예정일',
                          value: record.nextVisitat != null
                              ? DateFormat(
                                  'yyyy-MM-dd',
                                ).format(record.nextVisitat!)
                              : '정보 없음',
                        ),
                        const Divider(height: 32),

                        Text(
                          '방문 이유',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            (record.visitReason?.isNotEmpty ?? false)
                                ? record.visitReason!
                                : '방문 이유가 없습니다.',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        const Divider(height: 32),

                        Text(
                          '메모',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            (record.memo?.isNotEmpty ?? false)
                                ? record.memo!
                                : '메모가 없습니다.',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({required String label, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value ?? '정보 없음', style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
