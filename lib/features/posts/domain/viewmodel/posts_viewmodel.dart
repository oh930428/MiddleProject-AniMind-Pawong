import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/entities/post_filter_species.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/posts_repository.dart';

class PostsViewModel extends ChangeNotifier {
  final PostsRepository _postsRepository;

  // 게시글 전체
  List<HomePost> _allPosts = [];
  List<HomePost> _posts = [];
  List<HomePost> get posts => _posts;

  // 종 타입
  List<PostFilterSpecies> _species = [];
  List<PostFilterSpecies> get species => _species;

  String selectedSpecies = "전체";
  String selectedPostType = "전체";

  bool isLoading = false;

  PostsViewModel(this._postsRepository) {
    loadInitialPosts();
  }

  // 종 선택
  void setSpecies(String value) {
    selectedSpecies = value;
    _applyFilters();
  }

  // 게시글 타입 선택
  void setPostType(String value) {
    selectedPostType = value;
    _applyFilters();
  }

  // 서버에서 전체 데이터 로드
  Future<void> loadInitialPosts() async {
    isLoading = true;
    notifyListeners();

    try {
      _species = await _postsRepository.getSpecies();
      _allPosts = await _postsRepository.getAllPosts();
      _applyFilters(); // 로컬 필터 적용
    } catch (e) {
      _allPosts = [];
      _posts = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 선택된 필터 적용
  void _applyFilters() {
    _posts = _allPosts.where((post) {
      final matchSpecies =
          selectedSpecies == "전체" || post.species == selectedSpecies;
      final matchType =
          selectedPostType == "전체" || post.postType == selectedPostType;
      return matchSpecies && matchType;
    }).toList();
    notifyListeners();
  }
}
