import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/features/pet/data/repogitories/pet_repository.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/viewmodel/medical_records_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/medical_records.dart';
import '../domain/entities/pet.dart';

class MedicalRecordsScreen extends StatelessWidget {
  final Pet pet;

  const MedicalRecordsScreen({super.key, required this.pet});

  void _addOrEditRecord(
    BuildContext context,
    MedicalRecordsViewmodel viewModel, [
    MedicalRecords? record,
  ]) async {
    final result = await context.push<MedicalRecords>(
      '/profile/hospital_record/edit',
      extra: record,
    );

    if (result != null) {
      if (record == null) {
        await viewModel.addRecord(result);
      } else {
        await viewModel.updateRecord(result);
      }
    }
  }

  void _deleteRecord(
    BuildContext context,
    MedicalRecordsViewmodel viewModel,
    MedicalRecords record,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('병원 기록 삭제'),
        content: const Text('정말 이 병원 기록을 삭제하시겠습니까? \n 삭제된 기록은 복구할 수 없습니다'),
        actions: [
          OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade700, width: 2),
              foregroundColor: Colors.black,
            ),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (record.id != null) {
                await viewModel.deleteRecord(record.id!);
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicalRecordsViewmodel(PetRepository(), pet.id),
      child: Consumer<MedicalRecordsViewmodel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            // backgroundColor: AppColors.lightGrey,
            appBar: AppBar(title: Text('${pet.name} - 병원 기록')),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addOrEditRecord(context, viewModel),
              child: const Icon(Icons.add),
            ),
            body: _buildBody(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, MedicalRecordsViewmodel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.records.isEmpty) {
      return const Center(child: Text('등록된 병원 기록이 없습니다.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: viewModel.records.length,
      itemBuilder: (context, index) {
        final record = viewModel.records[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 8.0),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
          child: ListTile(
            leading: const Icon(Icons.local_hospital, color: AppColors.primary),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '다음 방문일: ${DateFormat('yyyy-MM-dd').format(record.nextVisitat!)}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _addOrEditRecord(context, viewModel, record),
                  tooltip: '수정',
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => _deleteRecord(context, viewModel, record),
                  tooltip: '삭제',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
