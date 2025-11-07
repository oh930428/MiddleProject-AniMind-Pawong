import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/pet_data.dart';

// 반려동물 정보를 추가하거나 수정하는 화면
class PetEditScreen extends StatefulWidget {
  final Pet? pet;

  const PetEditScreen({super.key, this.pet});

  @override
  _PetEditScreenState createState() => _PetEditScreenState();
}

class _PetEditScreenState extends State<PetEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _sexController;
  late TextEditingController _birthdayController;
  late TextEditingController _weightController;
  late TextEditingController _imageUrlController;

  String? _imageUrl; // 변경: String? 타입으로 변경
  File? _pickedImage; // 추가

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _speciesController = TextEditingController(text: widget.pet?.species ?? '');
    _breedController = TextEditingController(text: widget.pet?.breed ?? '');
    _ageController = TextEditingController(text: widget.pet?.age ?? '');
    _sexController = TextEditingController(text: widget.pet?.gender ?? '');
    _birthdayController = TextEditingController(
      text: widget.pet?.birthday ?? '',
    );
    _weightController = TextEditingController(
      text: widget.pet?.weight.toString() ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.pet?.imageUrl ?? '',
    );

    // 기존 이미지가 URL인지 파일 경로인지 확인하여 초기화
    if (widget.pet?.imageUrl != null &&
        widget.pet!.imageUrl.startsWith('http')) {
      _imageUrl = widget.pet?.imageUrl;
    } else if (widget.pet?.imageUrl != null &&
        widget.pet!.imageUrl.isNotEmpty) {
      _pickedImage = File(widget.pet!.imageUrl);
    }

    _imageUrlController.addListener(() {
      setState(() {
        _imageUrl = _imageUrlController.text;
        _pickedImage = null; // URL 입력 시 로컬 이미지 초기화
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    _birthdayController.dispose();
    _weightController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // 갤러리 또는 카메라에서 이미지를 선택하는 함수
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    ); // 갤러리에서 선택

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _imageUrl = null; // 로컬 이미지를 선택하면 URL은 초기화
        _imageUrlController.clear(); // URL 입력 필드도 초기화
      });
    }
  }

  // 저장 버튼을 눌렀을 때 호출되는 함수
  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newPet = Pet(
        id: widget.pet?.id ?? Random().nextInt(10000).toString(),
        name: _nameController.text,
        species: _speciesController.text,
        breed: _breedController.text,
        age: _ageController.text,
        gender: _sexController.text,
        birthday: _birthdayController.text,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        imageUrl: _pickedImage?.path ?? _imageUrlController.text, // 변경
      );
      Navigator.of(context).pop(newPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetColors.lightGrey,
      appBar: AppBar(title: Text(widget.pet == null ? '반려동물 추가' : '프로필 수정')),
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
              // 이미지 표시 영역
              Stack(
                // Stack 위젯 추가
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: PetColors.border,
                    backgroundImage:
                        _pickedImage !=
                            null // 변경
                        ? FileImage(_pickedImage!)
                              as ImageProvider // 로컬 이미지
                        : (_imageUrl != null &&
                                  _imageUrl!
                                      .isNotEmpty // 변경
                              ? NetworkImage(_imageUrl!) // 네트워크 이미지
                              : null),
                    onBackgroundImageError:
                        (_imageUrl != null && _imageUrl!.isNotEmpty)
                        ? (e, s) {}
                        : null, // 변경
                    child:
                        (_pickedImage == null &&
                            (_imageUrl == null || _imageUrl!.isEmpty)) // 변경
                        ? const Icon(Icons.pets, size: 60, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    // 이미지 선택 버튼 추가
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: PetColors.primary,
                      ), // 카메라 아이콘
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 입력 필드 카드
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _nameController,
                        labelText: '이름',
                        icon: Icons.pets,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _speciesController,
                        labelText: '종',
                        icon: Icons.category,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _breedController,
                        labelText: '품종',
                        icon: Icons.star,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _ageController,
                        labelText: '나이',
                        icon: Icons.cake,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _sexController,
                        labelText: '성별',
                        icon: Icons.wc,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _birthdayController,
                        labelText: '생일',
                        icon: Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _weightController,
                        labelText: '체중 (kg)',
                        icon: Icons.monitor_weight,
                        keyboardType: TextInputType.number,
                      ),
                      // const SizedBox(height: 16),
                      // _buildTextFormField(
                      //   controller: _imageUrlController,
                      //   labelText: '이미지',
                      //   icon: Icons.image,
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80), // FAB를 위한 공간
            ],
          ),
        ),
      ),
    );
  }

  // 텍스트 입력 필드를 생성하는 위젯
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: PetColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PetColors.primary, width: 2),
        ),
      ),
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
}
