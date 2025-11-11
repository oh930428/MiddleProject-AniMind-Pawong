import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/medical_records.dart';
import '../domain/viewmodel/medical_records_edit_viewmodel.dart';

class MedicalRecordsEditScreen extends StatelessWidget {
  final MedicalRecords? record;

  const MedicalRecordsEditScreen({super.key, this.record});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicalRecordsEditViewmodel(record),
      child: Consumer<MedicalRecordsEditViewmodel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(record == null ? '병원 기록 추가' : '병원 기록 수정'),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final result = await viewModel.saveRecord();
                if (result != null) {
                  context.pop(result);
                }
              },
              label: const Text('저장'),
              icon: const Icon(Icons.save),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: viewModel.formKey,
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
                              context,
                              controller: viewModel.visitDateController,
                              labelText: '방문일',
                              icon: Icons.calendar_today,
                              readOnly: true,
                              onTap: () => viewModel.selectDate(
                                context,
                                viewModel.visitDateController,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              context,
                              controller: viewModel.visitReasonController,
                              labelText: '방문 이유',
                              icon: Icons.medical_services_outlined,
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              context,
                              controller: viewModel.nextVisitDateController,
                              labelText: '다음 방문 예정일 (선택)',
                              icon: Icons.event_repeat,
                              readOnly: true,
                              onTap: () => viewModel.selectDate(
                                context,
                                viewModel.nextVisitDateController,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              context,
                              controller: viewModel.memoController,
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
        },
      ),
    );
  }

  Widget _buildTextFormField(
    BuildContext context, {
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
