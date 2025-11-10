import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../data/repogitories/pet_repository.dart';
import '../domain/entities/medical_records.dart';
import '../domain/entities/pet.dart';
import 'medical_records_edit_screen.dart';

class MedicalRecordsScreen extends StatefulWidget {
  final Pet pet;

  const MedicalRecordsScreen({super.key, required this.pet});

  @override
  _MedicalRecordsScreenState createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  late Future<List<MedicalRecords>> _recordsFuture;
  final PetRepository _repo = PetRepository();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    setState(() {
      _recordsFuture = _repo.getMedicalRecords(widget.pet.id);
    });
  }

  void _addOrEditRecord([MedicalRecords? record]) async {
    final result = await Navigator.of(context).push<MedicalRecords>(
      MaterialPageRoute(
        builder: (context) => HospitalRecordEditScreen(record: record),
      ),
    );

    if (result != null) {
      if (record == null) {
        // Add
        await _repo.addMedicalRecords(widget.pet.id, result);
      } else {
        // Edit
        await _repo.updateMedicalRecords(widget.pet.id, result);
      }
      _loadRecords();
    }
  }

  void _deleteRecord(MedicalRecords record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('병원 기록 삭제'),
        content: const Text('정말 이 병원 기록을 삭제하시겠습니까? \n 삭제된 기록은 복구할 수 없습니다'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade700, width: 2),
              foregroundColor: Colors.black,
            ),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _repo.deleteMedicalRecords(widget.pet.id, record.id);
              _loadRecords();
              Navigator.of(context).pop();
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
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: Text('${widget.pet.name} - 병원 기록')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditRecord(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<MedicalRecords>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('FutureBuilder error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return const Center(child: Text('등록된 병원 기록이 없습니다.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: AppColors.border, width: 1),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.local_hospital,
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
                        onPressed: () => _addOrEditRecord(record),
                        tooltip: '수정',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () => _deleteRecord(record),
                        tooltip: '삭제',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
