import '../../domain/entities/home_medical_records.dart';
import '../../domain/entities/home_pet.dart';
import '../../domain/entities/home_posts.dart';
import '../datasources/home_supabase_data.dart';

class HomeRepository {
  final HomeSupabaseDataSource homeSupabaseDataSource;

  HomeRepository(this.homeSupabaseDataSource);

  Future<List<HomePet>> getPets(String userId) async {
    try {
      final pets = await homeSupabaseDataSource.getPetWithDio(userId: userId);
      return pets;
    } catch (e) {
      print("🚨 HomeRepository.getPets 에러: $e");
      rethrow;
    }
  }

  Future<List<HomeMedicalRecords>> getMedicalRecords(String userId) async {
    try {
      final medicalRecords = await homeSupabaseDataSource
          .getMedicalRecordsWithDio(userId: userId);
      return medicalRecords;
    } catch (e) {
      print("🚨 HomeRepository.getMedicalRecords 에러: $e");
      rethrow;
    }
  }

  Future<List<HomePost>> getPosts(String userId) async {
    try {
      final posts = await homeSupabaseDataSource.getPostsWithDio(
        userId: userId,
      );
      return posts;
    } catch (e) {
      print("🚨 HomeRepository.getPosts 에러: $e");
      rethrow;
    }
  }
}
