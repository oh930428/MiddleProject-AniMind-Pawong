import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  late TextEditingController _sexController;
  late TextEditingController _birthdateController;
  late TextEditingController _weightController;
  late TextEditingController _imageUrlController;
  bool _isNeutered = false;

  String? _imageUrl;
  File? _pickedImage;

  List<Map<String, dynamic>> _speciesList = [];
  List<Map<String, dynamic>> _breedsList = [];
  int? _selectedSpeciesId;
  int? _selectedBreedId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.pet?.name ?? "");
    _sexController = TextEditingController(text: widget.pet?.gender ?? "");
    _birthdateController = TextEditingController(
      text: widget.pet?.birthDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.pet!.birthDate!)
          : "",
    );
    _weightController = TextEditingController(
      text: widget.pet?.weight?.toString() ?? " ",
    );
    _imageUrlController = TextEditingController(
      text: widget.pet?.imageUrl ?? "",
    );
    _isNeutered = widget.pet?.isNeutered ?? false;

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
        _pickedImage = null;
      });
    });

    _getSpecies();
  }

  Future<void> _getSpecies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('species')
          .select('id, species_name');

      final List<Map<String, dynamic>> species = response
          .map((e) => {'id': e['id'], 'name': e['species_name'] as String})
          .toList();

      setState(() {
        _speciesList = species;
        if (widget.pet != null) {
          final petSpeciesName = widget.pet!.species_name;
          final matchingSpecies = _speciesList.firstWhere(
            (s) => s['name'] == petSpeciesName,
            orElse: () => {},
          );
          if (matchingSpecies.isNotEmpty) {
            _selectedSpeciesId = matchingSpecies['id'];
            if (_selectedSpeciesId != null) {
              _getBreeds(_selectedSpeciesId!);
            }
          }
        }
      });
    } catch (e, stackTrace) {
      print('Error getting species: $e');
      print(stackTrace);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getBreeds(int speciesId) async {
    try {
      final response = await Supabase.instance.client
          .from('breeds')
          .select('id, breeds_name')
          .eq('species_id', speciesId);

      final List<Map<String, dynamic>> breeds = response
          .map((e) => {'id': e['id'], 'name': e['breeds_name'] as String})
          .toList();

      setState(() {
        _breedsList = breeds;
        _selectedBreedId = null;

        if (widget.pet != null &&
            widget.pet!.breedId != null &&
            _breedsList.any((b) => b['id'] == widget.pet!.breedId)) {
          _selectedBreedId = widget.pet!.breedId;
        } else if (_breedsList.isNotEmpty) {
          _selectedBreedId = _breedsList.first['id'];
        }
      });
    } catch (e, stackTrace) {
      print('Error getting breeds for species ID $speciesId: $e');
      print(stackTrace);
      // 에러 처리
    }
  }

  ImageProvider? _getImageProvider() {
    if (_pickedImage != null) {
      return FileImage(_pickedImage!);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return NetworkImage(_imageUrl!);
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sexController.dispose();
    _birthdateController.dispose();
    _weightController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _imageUrl = null;
        _imageUrlController.clear();
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final birthDate = _birthdateController.text.isNotEmpty
          ? DateTime.parse(_birthdateController.text)
          : null;
      final age = birthDate != null
          ? (DateTime.now().difference(birthDate).inDays / 365)
                .floor()
                .toString()
          : '0';

      final selectedSpeciesName = _selectedSpeciesId != null
          ? _speciesList.firstWhere(
                  (s) => s['id'] == _selectedSpeciesId,
                )['name']
                as String
          : '';

      final selectedBreedName = _selectedBreedId != null
          ? _breedsList.firstWhere((b) => b['id'] == _selectedBreedId)['name']
                as String
          : '';

      final newPet = Pet(
        id: widget.pet?.id ?? Random().nextInt(10000).toString(),
        name: _nameController.text,
        species_name: selectedSpeciesName,
        breeds_name: selectedBreedName,
        breedId: _selectedBreedId,
        age: age,
        gender: _sexController.text,
        birthDate: birthDate,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        imageUrl: _pickedImage?.path ?? _imageUrlController.text,
        isNeutered: _isNeutered,
        tags: widget.pet?.tags ?? [],
        infoGridData: widget.pet?.infoGridData ?? [],
        records: widget.pet?.records ?? [],
      );
      Navigator.of(context).pop(newPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: Text(widget.pet == null ? '반려동물 추가' : '프로필 수정')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSave,
        label: const Text('저장'),
        icon: const Icon(Icons.save),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Builder(
                      builder: (context) {
                        final imageProvider = _getImageProvider();
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.border,
                              backgroundImage: imageProvider,
                              onBackgroundImageError: imageProvider != null
                                  ? (e, s) {
                                      print('Image load error: $e\n$s');
                                    }
                                  : null,
                              child: imageProvider == null
                                  ? const Icon(
                                      Icons.pets,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.primary,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
                              controller: _nameController,
                              labelText: '이름',
                              icon: Icons.pets,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<int>(
                              value: _selectedSpeciesId,
                              items: _speciesList.map((species) {
                                return DropdownMenuItem<int>(
                                  value: species['id'] as int,
                                  child: Text(species['name'] as String),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSpeciesId = value;
                                  _selectedBreedId = null;
                                  _breedsList = [];
                                  if (_selectedSpeciesId != null) {
                                    _getBreeds(_selectedSpeciesId!);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: '종',
                                prefixIcon: const Icon(
                                  Icons.category,
                                  color: AppColors.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return '종을 선택해주세요.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<int>(
                              value: _selectedBreedId,
                              items: _breedsList.map((breed) {
                                return DropdownMenuItem<int>(
                                  value: breed['id'] as int,
                                  child: Text(breed['name'] as String),
                                );
                              }).toList(),
                              onChanged: _selectedSpeciesId != null
                                  ? (value) {
                                      setState(() {
                                        _selectedBreedId = value;
                                      });
                                    }
                                  : null,
                              decoration: InputDecoration(
                                labelText: '품종',
                                prefixIcon: const Icon(
                                  Icons.star,
                                  color: AppColors.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return '품종을 선택해주세요.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _sexController,
                              labelText: '성별',
                              icon: Icons.wc,
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _birthdateController,
                              labelText: '생일 (YYYY-MM-DD)',
                              icon: Icons.calendar_today,
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _weightController,
                              labelText: '체중 (kg)',
                              icon: Icons.monitor_weight,
                              keyboardType: TextInputType.number,
                            ),
                            SwitchListTile(
                              title: const Text('중성화 여부'),
                              value: _isNeutered,
                              onChanged: (bool value) {
                                setState(() {
                                  _isNeutered = value;
                                });
                              },
                              secondary: const Icon(
                                Icons.medical_services_outlined,
                                color: AppColors.primary,
                              ),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildDropdownFormField({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String labelText,
    required IconData icon,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText 항목을 선택해주세요.';
        }
        return null;
      },
    );
  }
}
