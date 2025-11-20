import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repogitories/pet_repository.dart';
import '../entities/pet.dart';

class PetEditViewModel extends ChangeNotifier {
  final PetRepository _repo = PetRepository();
  final Pet? _initialPet;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  String? selectedGender;
  String? _genderErrorText;
  String? get genderErrorText => _genderErrorText;
  late TextEditingController birthdateController;
  late TextEditingController weightController;
  bool isNeutered = false;

  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  List<Map<String, dynamic>> _speciesList = [];
  List<Map<String, dynamic>> get speciesList => _speciesList;

  List<Map<String, dynamic>> _breedsList = [];
  List<Map<String, dynamic>> get breedsList => _breedsList;

  int? _selectedSpeciesId;
  int? get selectedSpeciesId => _selectedSpeciesId;

  int? _selectedBreedId;
  int? get selectedBreedId => _selectedBreedId;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  PetEditViewModel(this._initialPet) {
    nameController = TextEditingController(text: _initialPet?.name ?? "");
    selectedGender = _initialPet?.gender ?? '남아';
    birthdateController = TextEditingController(
      text: _initialPet?.birthDate != null
          ? DateFormat('yyyy-MM-dd').format(_initialPet!.birthDate!)
          : "",
    );
    weightController = TextEditingController(
      text: _initialPet?.weight?.toString() ?? "",
    );
    isNeutered = _initialPet?.isNeutered ?? false;
    _imageUrl = _initialPet?.imageUrl;

    _getSpecies();
  }

  Future<void> _getSpecies() async {
    _setLoading(true);
    try {
      final response = await Supabase.instance.client
          .from('species')
          .select('id, species_name');
      _speciesList = response
          .map((e) => {'id': e['id'], 'name': e['species_name'] as String})
          .toList();

      if (_initialPet != null) {
        final petSpeciesName = _initialPet!.species_name;
        final matchingSpecies = _speciesList.firstWhere(
          (s) => s['name'] == petSpeciesName,
          orElse: () => {},
        );
        if (matchingSpecies.isNotEmpty) {
          _selectedSpeciesId = matchingSpecies['id'];
          if (_selectedSpeciesId != null) {
            await _getBreeds(_selectedSpeciesId!);
          }
        }
      }
    } catch (e) {
      print('Error getting species: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _getBreeds(int speciesId) async {
    try {
      final response = await Supabase.instance.client
          .from('breeds')
          .select('id, breeds_name')
          .eq('species_id', speciesId);
      _breedsList = response
          .map((e) => {'id': e['id'], 'name': e['breeds_name'] as String})
          .toList();

      if (_initialPet != null &&
          _initialPet!.breedId != null &&
          _breedsList.any((b) => b['id'] == _initialPet!.breedId)) {
        _selectedBreedId = _initialPet!.breedId;
      } else if (_breedsList.isNotEmpty) {
        _selectedBreedId = _breedsList.first['id'];
      }
    } catch (e) {
      print('Error getting breeds for species ID $speciesId: $e');
    }
    notifyListeners();
  }

  void onSpeciesChanged(int? value) {
    _selectedSpeciesId = value;
    _selectedBreedId = null;
    _breedsList = [];
    if (_selectedSpeciesId != null) {
      _getBreeds(_selectedSpeciesId!);
    }
    notifyListeners();
  }

  void onBreedChanged(int? value) {
    _selectedBreedId = value;
    notifyListeners();
  }

  void onGenderChanged(String? value) {
    selectedGender = value;
    _genderErrorText = null;
    notifyListeners();
  }

  void onNeuteredChanged(bool value) {
    isNeutered = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      _imageUrl = null;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> savePet() async {
    final isFormValid = formKey.currentState!.validate();

    if (!isFormValid) {
      notifyListeners();
      return null;
    }

    final birthDate = birthdateController.text.isNotEmpty
        ? DateTime.parse(birthdateController.text)
        : null;
    final age = birthDate != null
        ? (DateTime.now().difference(birthDate).inDays / 365).floor().toString()
        : '0';

    final selectedSpeciesName = _selectedSpeciesId != null
        ? _speciesList.firstWhere((s) => s['id'] == _selectedSpeciesId)['name']
              as String
        : '';

    final selectedBreedName = _selectedBreedId != null
        ? _breedsList.firstWhere((b) => b['id'] == _selectedBreedId)['name']
              as String
        : '';

    final newPet = Pet(
      id: _initialPet?.id ?? '',
      name: nameController.text,
      species_name: selectedSpeciesName,
      breeds_name: selectedBreedName,
      breedId: _selectedBreedId,
      age: age,
      gender: selectedGender ?? '',
      birthDate: birthDate,
      weight: double.tryParse(weightController.text) ?? 0.0,
      imageUrl: _pickedImage?.path ?? _imageUrl ?? '',
      isNeutered: isNeutered,
      tags: _initialPet?.tags ?? [],
      infoGridData: _initialPet?.infoGridData ?? [],
      records: _initialPet?.records ?? [],
    );

    return {'pet': newPet, 'image': _pickedImage};
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
