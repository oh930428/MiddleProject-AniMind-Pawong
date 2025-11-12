import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/auth/domain/viewmodel/auth_viewmodel.dart';
import 'package:middleproject_animind_pawong/features/home/data/repositories/home_repository.dart';
import 'package:middleproject_animind_pawong/features/home/domain/entities/home_medical_records.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';

import '../../domain/entities/home_pet.dart';
import '../../domain/entities/home_posts.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _homeRepository;
  final String userId;

  List<HomePet> _pets = [];
  List<HomePet> get pets => _pets;

  List<HomeMedicalRecords> _medicalRecords = [];
  List<HomeMedicalRecords> get medicalRecords => _medicalRecords;

  List<HomePost> _posts = [];
  List<HomePost> get posts => _posts;

  bool isLoading = false;

  HomeViewModel(this._homeRepository, this.userId) {
    loadInitialHome();
  }

  Future<void> loadInitialHome() async {
    isLoading = true;
    notifyListeners();

    try {
      _pets = await _homeRepository.getPets(userId);
      _medicalRecords = await _homeRepository.getMedicalRecords(userId);
      _posts = await _homeRepository.getPosts(userId);
    } catch (e) {
      _pets = [];
      _medicalRecords = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
