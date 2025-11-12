import '../../../home/domain/entities/home_posts.dart';
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
      print("🚨 HomeRepository.getPosts 에러: $e");
      rethrow;
    }
  }

  // 게시글 - 전체 불러오기
  Future<List<HomePost>> getAllPosts() async {
    try {
      final posts = await postsSupabaseDataSource.getAllPostsWithDio();
      return posts;
    } catch (e) {
      print("🚨 HomeRepository.getPosts 에러: $e");
      rethrow;
    }
  }
}
