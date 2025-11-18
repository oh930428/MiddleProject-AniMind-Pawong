import 'dart:io';

import '../../../home/domain/entities/home_posts.dart';
import '../../domain/entities/breed.dart';
import '../../domain/entities/post_filter_species.dart';
import '../datasources/posts_supabase_data.dart';

class PostsRepository {
  final PostsSupabaseDataSource postsSupabaseDataSource;

  PostsRepository(this.postsSupabaseDataSource);

  // 게시글 - 종 불러오기
  Future<List<PostFilterSpecies>> getSpecies() async {
    try {
      final species = await postsSupabaseDataSource.getSpeciesWithDio();
      return species;
    } catch (e) {
      print("🚨 PostsRepository.getSpecies 에러: $e");
      rethrow;
    }
  }

  // 게시글 - 품종 불러오기 (by species_id)
  Future<List<Breed>> getBreedsBySpeciesId(int speciesId) async {
    try {
      final breeds = await postsSupabaseDataSource.getBreedsBySpeciesIdWithDio(
        speciesId,
      );
      return breeds;
    } catch (e) {
      print("🚨 PostsRepository.getBreedsBySpeciesId 에러: $e");
      rethrow;
    }
  }

  // 게시글 - 전체 불러오기
  Future<List<HomePost>> getAllPosts() async {
    try {
      final posts = await postsSupabaseDataSource.getAllPostsWithDio();
      return posts;
    } catch (e) {
      print("🚨 PostsRepository.getAllPosts 에러: $e");
      rethrow;
    }
  }

  // 게시글 - 특정 게시물 불러오기
  Future<HomePost> getByIdPost(int postId) async {
    try {
      final posts = await postsSupabaseDataSource.getByIdPostWithDio(postId);
      return posts;
    } catch (e) {
      print("🚨 PostsRepository.getByIdPost error: $e");
      rethrow;
    }
  }

  // 게시글 이미지 업로드
  Future<String> uploadImage({
    required File pickedImage,
    required String userId,
  }) async {
    try {
      return await postsSupabaseDataSource.uploadImage(
        pickedImage: pickedImage,
        userId: userId,
      );
    } catch (e) {
      print("🚨 PostsRepository.uploadImage 에러: $e");
      rethrow;
    }
  }

  // 게시글 - 추가
  Future<void> addPosts({
    required String userId,
    required String postType,
    required String title,
    required String content,
    required String gender,
    required String birth,
    required String weight,
    required String? imageUrl,
    required int? breedsId,
  }) async {
    try {
      await postsSupabaseDataSource.addPostsWithDio(
        userId: userId,
        postType: postType,
        title: title,
        content: content,
        gender: gender,
        birth: birth,
        weight: weight,
        imageUrl: imageUrl,
        breedsId: breedsId,
      );
    } catch (e) {
      print("🚨 PostsRepository.addPosts 에러: $e");
      rethrow;
    }
  }

  // 게시글 - 수정
  Future<void> updatePosts({
    required String postId,
    required String postType,
    required String title,
    required String content,
    required String gender,
    required String birth,
    required String weight,
    required String? imageUrl,
    required int? breedsId,
  }) async {
    try {
      await postsSupabaseDataSource.updatePostsWithDio(
        postId: postId,
        postType: postType,
        title: title,
        content: content,
        gender: gender,
        birth: birth,
        weight: weight,
        imageUrl: imageUrl,
        breedsId: breedsId,
      );
    } catch (e) {
      print("🚨 PostsRepository.updatePosts 에러: $e");
      rethrow;
    }
  }

  // 게시글 - 삭제
  Future<void> deletePosts({required String postId}) async {
    try {
      await postsSupabaseDataSource.deletedPostsWithDio(postId);
    } catch (e) {
      print("🚨 PostsRepository.deletePosts 에러: $e");
      rethrow;
    }
  }
}
