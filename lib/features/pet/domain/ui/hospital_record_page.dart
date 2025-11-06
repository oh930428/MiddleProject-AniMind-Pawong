import 'dart:math';

import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/utils.dart';

import '../entities/pet_data.dart';

class HospitalRecordScreen extends StatefulWidget {
  final Pet pet;

  const HospitalRecordScreen({super.key, required this.pet});

  @override
  _HospitalRecordScreenState createState() => _HospitalRecordScreenState();
}

class _HospitalRecordScreenState extends State<HospitalRecordScreen> {
  late List<HospitalRecord> _records;
  final PetRepository _repo = PetRepository();

  @override
  void initState() {
    super.initState();
    _records = _repo.getHospitalRecords(widget.pet.id);
  }

  void _addOrEditRecord([HospitalRecord? record]) async {
    final result = await showDialog<HospitalRecord>(
      context: context,
      builder: (context) => _RecordEditDialog(record: record),
    );

    if (result != null) {
      setState(() {
        if (record == null) {
          // Add
          _repo.addHospitalRecord(widget.pet.id, result);
        } else {
          // Edit
          _repo.updateHospitalRecord(widget.pet.id, result);
        }
        _records = _repo.getHospitalRecords(widget.pet.id);
      });
    }
  }

  void _deleteRecord(HospitalRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('기록 삭제'),
        content: const Text('이 병원 기록을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _repo.deleteHospitalRecord(widget.pet.id, record.id);
                _records = _repo.getHospitalRecords(widget.pet.id);
              });
              Navigator.of(context).pop();
            },
            child: Text(
              '삭제',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetColors.lightGrey,
      appBar: AppBar(title: Text('${widget.pet.name} - 병원 기록')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditRecord(),
        child: const Icon(Icons.add),
      ),
      body: _records.isEmpty
          ? const Center(child: Text('등록된 병원 기록이 없습니다.'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppLayout.horizontalPadding),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return Card(
                  margin: const EdgeInsets.only(
                    bottom: AppLayout.elementSpacing,
                  ),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                    side: const BorderSide(color: PetColors.border, width: 1),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_hospital,
                      color: PetColors.primary,
                    ),
                    title: Text(
                      record.visitReason,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('방문일: ${record.visitDate}'),
                        Text('메모: ${record.memo}'),
                        if (record.nextVisitDate != null &&
                            record.nextVisitDate!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '다음 방문일: ${record.nextVisitDate}',
                              style: TextStyle(
                                color: PetColors.primary,
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
            ),
    );
  }
}

class _RecordEditDialog extends StatefulWidget {
  final HospitalRecord? record;

  const _RecordEditDialog({this.record});

  @override
  __RecordEditDialogState createState() => __RecordEditDialogState();
}

class __RecordEditDialogState extends State<_RecordEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _visitDateController;
  late TextEditingController _visitReasonController;
  late TextEditingController _nextVisitDateController;
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _visitDateController = TextEditingController(
      text:
          widget.record?.visitDate ??
          DateTime.now().toIso8601String().substring(0, 10),
    );
    _visitReasonController = TextEditingController(
      text: widget.record?.visitReason ?? '',
    );
    _nextVisitDateController = TextEditingController(
      text: widget.record?.nextVisitDate ?? '',
    );
    _memoController = TextEditingController(text: widget.record?.memo ?? '');
  }

  @override
  void dispose() {
    _visitDateController.dispose();
    _visitReasonController.dispose();
    _nextVisitDateController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newRecord = HospitalRecord(
        id: widget.record?.id ?? Random().nextInt(10000).toString(),
        visitDate: _visitDateController.text,
        visitReason: _visitReasonController.text,
        nextVisitDate: _nextVisitDateController.text.isNotEmpty
            ? _nextVisitDateController.text
            : null,
        memo: _memoController.text,
      );
      Navigator.of(context).pop(newRecord);
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      controller.text = date.toIso8601String().substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.record == null ? '기록 추가' : '기록 수정'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _visitDateController,
                decoration: const InputDecoration(
                  labelText: '방문일',
                  icon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _visitDateController),
                validator: (value) =>
                    (value == null || value.isEmpty) ? '방문일을 입력하세요' : null,
              ),
              TextFormField(
                controller: _visitReasonController,
                decoration: const InputDecoration(
                  labelText: '방문 이유',
                  icon: Icon(Icons.medical_services_outlined),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? '방문 이유를 입력하세요' : null,
              ),
              TextFormField(
                controller: _nextVisitDateController,
                decoration: const InputDecoration(
                  labelText: '다음 방문 예정일 (선택)',
                  icon: Icon(Icons.event_repeat),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _nextVisitDateController),
              ),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(
                  labelText: '메모',
                  icon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(onPressed: _onSave, child: const Text('저장')),
      ],
    );
  }
}
