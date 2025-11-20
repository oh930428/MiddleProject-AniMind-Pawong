import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entities/medical_records.dart';

class MedicalRecordsEditViewmodel extends ChangeNotifier {
  final MedicalRecords? _initialRecord;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController visitDateController;
  late TextEditingController visitReasonController;
  late TextEditingController nextVisitDateController;
  late TextEditingController memoController;

  MedicalRecordsEditViewmodel(this._initialRecord) {
    visitDateController = TextEditingController(
      text: _initialRecord?.visitedat == null
          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
          : DateFormat('yyyy-MM-dd').format(_initialRecord!.visitedat!),
    );
    visitReasonController = TextEditingController(
      text: _initialRecord?.visitReason ?? '',
    );
    nextVisitDateController = TextEditingController(
      text: _initialRecord?.nextVisitat == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(_initialRecord!.nextVisitat!),
    );
    memoController = TextEditingController(text: _initialRecord?.memo ?? '');
  }

  @override
  void dispose() {
    visitDateController.dispose();
    visitReasonController.dispose();
    nextVisitDateController.dispose();
    memoController.dispose();
    super.dispose();
  }

  Future<MedicalRecords?> saveRecord() async {
    if (formKey.currentState!.validate()) {
      final newRecord = MedicalRecords(
        id: _initialRecord?.id,
        visitedat: DateTime.parse(visitDateController.text),
        visitReason: visitReasonController.text,
        nextVisitat: nextVisitDateController.text.isNotEmpty
            ? DateTime.parse(nextVisitDateController.text)
            : null,
        memo: memoController.text,
      );
      return newRecord;
    }
    return null;
  }

  Future<void> selectDate(
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
}
