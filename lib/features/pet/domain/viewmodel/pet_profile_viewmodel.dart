import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/repogitories/pet_repository.dart';
import '../entities/medical_records.dart';
import '../entities/pet.dart';

class PetProfileViewModel extends ChangeNotifier {
  final PetRepository _repo = PetRepository();

  List<Pet> _pets = [];
  List<Pet> get pets => _pets;

  Pet? _selectedPet;
  Pet? get selectedPet => _selectedPet;

  List<MedicalRecords> _records = [];
  List<MedicalRecords> get records => _records;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PetProfileViewModel() {
    loadPets();
  }

  Future<void> loadPets() async {
    _setLoading(true);
    try {
      _pets = await _repo.getAllPets();
      if (_pets.isNotEmpty) {
        _selectedPet = _pets.first;
        await loadMedicalRecords(_selectedPet!.id);
      } else {
        _selectedPet = null;
        _records = [];
      }
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMedicalRecords(String? petId) async {
    if (petId == null) {
      _records = [];
      notifyListeners();
      return;
    }
    _setLoading(true);
    try {
      _records = await _repo.getMedicalRecords(petId);
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  void selectPet(Pet pet) {
    if (_selectedPet?.id != pet.id) {
      _selectedPet = pet;
      loadMedicalRecords(pet.id);
      notifyListeners();
    }
  }

  Future<void> addPet(Pet pet, File? imageFile) async {
    _setLoading(true);
    try {
      await _repo.addPet(pet, imageFile);
      await loadPets();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePet(Pet pet, File? imageFile) async {
    _setLoading(true);
    try {
      await _repo.updatePet(pet, imageFile);
      await loadPets();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePet(String petId) async {
    _setLoading(true);
    try {
      await _repo.deletePet(petId);
      await loadPets();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
