import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/posts_repository.dart';
import '../entities/post_filter_species.dart';

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

  // 게시글 - 추가
  Future<void> addPosts({
    required String postType,
    required String title,
    required String content,
    required String species,
    required String breeds,
    required String gender,
    required String birth,
    required String weight,
    required String imageUrl,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final userId = Supabase.instance.client.auth.currentSession!.user.id;

      final file = File(imageUrl);
      final bytes = await file.readAsBytes();

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      await Supabase.instance.client.storage
          .from('pet_image') // 생성한 버킷 이름
          .uploadBinary(fileName, bytes);

      final String publicUrl = Supabase.instance.client.storage
          .from('pet_image')
          .getPublicUrl(fileName);

      await _postsRepository.addPosts(
        userId: userId,
        postType: postType,
        title: title,
        content: content,
        species: species,
        breeds: breeds,
        gender: gender,
        birth: birth,
        weight: weight,
        imageUrl: publicUrl,
      );

      await loadInitialPosts();
    } catch (e) {
      debugPrint("게시글 추가 실패: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 게시글 - 수정
  Future<void> updatePosts({
    required String postId,
    required String postType,
    required String title,
    required String content,
    required String species,
    required String breeds,
    required String gender,
    required String birth,
    required String weight,
    // required String imageUrl,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // final file = File(imageUrl);
      // final bytes = await file.readAsBytes();
      //
      // final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      //
      // await Supabase.instance.client.storage
      //     .from('pet_image') // 생성한 버킷 이름
      //     .uploadBinary(fileName, bytes);
      //
      // final String publicUrl = Supabase.instance.client.storage
      //     .from('pet_image')
      //     .getPublicUrl(fileName);

      await _postsRepository.updatePosts(
        postId: postId,
        postType: postType,
        title: title,
        content: content,
        species: species,
        breeds: breeds,
        gender: gender,
        birth: birth,
        weight: weight,
        // imageUrl: publicUrl,
      );

      await loadInitialPosts();
    } catch (e) {
      debugPrint("게시글 수정 실패: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 게시글 - 삭제
  Future<void> deletePosts({required String postId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _postsRepository.deletePosts(postId: postId);

      await loadInitialPosts();
    } catch (e) {
      debugPrint("게시글 삭제 실패: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
