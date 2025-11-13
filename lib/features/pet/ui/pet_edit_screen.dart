import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';
import 'package:provider/provider.dart';

import '../domain/viewmodel/pet_edit_viewmodel.dart';

class PetEditScreen extends StatelessWidget {
  final Pet? pet;

  const PetEditScreen({super.key, this.pet});

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
    return ChangeNotifierProvider(
      create: (_) => PetEditViewModel(pet),
      child: Consumer<PetEditViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text(pet == null ? '반려동물 추가' : '프로필 수정')),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final result = await viewModel.savePet();
                if (result != null) {
                  context.pop(result);
                }
              },
              label: const Text('저장'),
              icon: const Icon(Icons.save),
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildForm(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, PetEditViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: viewModel.formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            _buildImagePicker(context, viewModel),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextFormField(
                      controller: viewModel.nameController,
                      labelText: '이름',
                      icon: Icons.pets,
                    ),
                    const SizedBox(height: 16),
                    _buildSpeciesDropdown(viewModel),
                    const SizedBox(height: 16),
                    _buildBreedsDropdown(viewModel),
                    const SizedBox(height: 16),
                    _buildGenderRadio(viewModel),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: viewModel.birthdateController,
                      labelText: '생일 (YYYY-MM-DD)',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () =>
                          _selectDate(context, viewModel.birthdateController),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: viewModel.weightController,
                      labelText: '체중 (kg)',
                      icon: Icons.monitor_weight,
                      keyboardType: TextInputType.number,
                    ),
                    _buildNeuteredSwitch(viewModel),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, PetEditViewModel viewModel) {
    ImageProvider? imageProvider;
    if (viewModel.pickedImage != null) {
      imageProvider = FileImage(viewModel.pickedImage!);
    } else if (viewModel.imageUrl != null && viewModel.imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(viewModel.imageUrl!);
    }
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.border,
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.pets, size: 60, color: Colors.white)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: AppColors.primary),
            onPressed: () => viewModel.pickImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesDropdown(PetEditViewModel viewModel) {
    return DropdownButtonFormField<int>(
      value: viewModel.selectedSpeciesId,
      items: viewModel.speciesList.map((species) {
        return DropdownMenuItem<int>(
          value: species['id'] as int,
          child: Text(species['name'] as String),
        );
      }).toList(),
      onChanged: (value) => viewModel.onSpeciesChanged(value),
      decoration: _inputDecoration('종', Icons.category),
      validator: (value) => value == null ? '종을 선택해주세요.' : null,
    );
  }

  Widget _buildBreedsDropdown(PetEditViewModel viewModel) {
    return DropdownButtonFormField<int>(
      value: viewModel.selectedBreedId,
      items: viewModel.breedsList.map((breed) {
        return DropdownMenuItem<int>(
          value: breed['id'] as int,
          child: Text(breed['name'] as String),
        );
      }).toList(),
      onChanged: viewModel.selectedSpeciesId != null
          ? (value) => viewModel.onBreedChanged(value)
          : null,
      decoration: _inputDecoration('품종', Icons.star),
      validator: (value) => value == null ? '품종을 선택해주세요.' : null,
    );
  }

  Widget _buildGenderRadio(PetEditViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12.0, bottom: 8.0),
          child: Text(
            '성별',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('남아'),
                value: '남아',
                groupValue: viewModel.selectedGender,
                onChanged: (value) => viewModel.onGenderChanged(value),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('여아'),
                value: '여아',
                groupValue: viewModel.selectedGender,
                onChanged: (value) => viewModel.onGenderChanged(value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNeuteredSwitch(PetEditViewModel viewModel) {
    return SwitchListTile(
      title: const Text('중성화 여부'),
      value: viewModel.isNeutered,
      onChanged: (value) => viewModel.onNeuteredChanged(value),
      secondary: const Icon(
        Icons.medical_services_outlined,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: _inputDecoration(labelText, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText 항목을 입력해주세요.';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return '유효한 숫자를 입력해주세요.';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: AppColors.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
