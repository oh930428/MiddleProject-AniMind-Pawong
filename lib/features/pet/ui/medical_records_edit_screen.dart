import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/medical_records.dart';

class HospitalRecordEditScreen extends StatefulWidget {
  final MedicalRecords? record;

  const HospitalRecordEditScreen({super.key, this.record});

  @override
  _HospitalRecordEditScreenState createState() =>
      _HospitalRecordEditScreenState();
}

class _HospitalRecordEditScreenState extends State<HospitalRecordEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _visitDateController;
  late TextEditingController _visitReasonController;
  late TextEditingController _nextVisitDateController;
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _visitDateController = TextEditingController(
      text: widget.record?.visitedat == null
          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
          : DateFormat('yyyy-MM-dd').format(widget.record!.visitedat!),
    );
    _visitReasonController = TextEditingController(
      text: widget.record?.visitReason ?? '',
    );
    _nextVisitDateController = TextEditingController(
      text: widget.record?.nextVisitat == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(widget.record!.nextVisitat!),
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
      final newRecord = MedicalRecords(
        id: widget.record?.id ?? Random().nextInt(10000).toString(),
        visitedat: DateTime.parse(_visitDateController.text),
        visitReason: _visitReasonController.text,
        nextVisitat: _nextVisitDateController.text.isNotEmpty
            ? DateTime.parse(_nextVisitDateController.text)
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
      controller.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.record == null ? '병원 기록 추가' : '병원 기록 수정'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSave,
        label: const Text('저장'),
        icon: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _visitDateController,
                        labelText: '방문일',
                        icon: Icons.calendar_today,
                        readOnly: true,
                        onTap: () => _selectDate(context, _visitDateController),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _visitReasonController,
                        labelText: '방문 이유',
                        icon: Icons.medical_services_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _nextVisitDateController,
                        labelText: '다음 방문 예정일 (선택)',
                        icon: Icons.event_repeat,
                        readOnly: true,
                        onTap: () =>
                            _selectDate(context, _nextVisitDateController),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _memoController,
                        labelText: '메모',
                        icon: Icons.note,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int? maxLines = 1,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (labelText.contains('(선택)')) {
            return null;
          }
          return '$labelText 항목을 입력해주세요.';
        }
        return null;
      },
    );
  }
}
