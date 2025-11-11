import 'package:flutter/material.dart';

import '../../data/repogitories/pet_repository.dart';
import '../entities/medical_records.dart';

class MedicalRecordsViewmodel extends ChangeNotifier {
  final PetRepository _repo;
  final String? _petId;

  List<MedicalRecords> _records = [];
  List<MedicalRecords> get records => _records;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MedicalRecordsViewmodel(this._repo, this._petId) {
    loadRecords();
  }

  Future<void> loadRecords() async {
    if (_petId == null) return;
    _setLoading(true);
    try {
      _records = await _repo.getMedicalRecords(_petId!);
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addRecord(MedicalRecords record) async {
    if (_petId == null) return;
    _setLoading(true);
    try {
      await _repo.addMedicalRecords(_petId!, record);
      await loadRecords();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateRecord(MedicalRecords record) async {
    if (_petId == null) return;
    _setLoading(true);
    try {
      await _repo.updateMedicalRecords(_petId!, record);
      await loadRecords();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteRecord(String recordId) async {
    if (_petId == null) return;
    _setLoading(true);
    try {
      await _repo.deleteMedicalRecords(_petId!, recordId);
      await loadRecords();
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
