import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pet/domain/entities/hospital_records.dart';

class HospitalCard extends StatelessWidget {
  final HospitalRecord record;

  const HospitalCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        side: const BorderSide(color: PetColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          spacing: 10,
          children: [
            const Icon(Icons.local_hospital_outlined, color: PetColors.primary),
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
                  if (record.nextVisitAt != null &&
                      record.nextVisitAt!.isNotEmpty)
                    Text(
                      '다음 방문: ${record.nextVisitAt}',
                      style: TextStyle(
                        color: PetColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              record.visitedAt,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
