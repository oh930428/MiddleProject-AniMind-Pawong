import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/features/posts/data/repositories/posts_repository.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/viewmodel/posts_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/viewmodel/home_viewmodel.dart';
import '../../../home/presentation/widgets/post_card.dart';
import '../widgets/filter_section.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostsViewModel(context.read<PostsRepository>()),
      child: _PostsScreen(),
    );
  }
}

class _PostsScreen extends StatelessWidget {
  const _PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animind - 게시글',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/posts/add"),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<PostsViewModel>(
            builder: (context, viewModel, child) {
              final species = [
                "전체",
                ...viewModel.species.map((e) => e.speciesName),
              ];
              final postType = ["전체", "게시글", "Q&A"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  // 종 필터
                  FilterSection(
                    title: "종 타입",
                    options: species,
                    selectedValue: viewModel.selectedSpecies,
                    onSelected: (value) => viewModel.setSpecies(value),
                  ),

                  Divider(color: Colors.black.withOpacity(0.2), height: 2),

                  // 게시글 타입 필터
                  FilterSection(
                    title: "타입",
                    options: postType,
                    selectedValue: viewModel.selectedPostType,
                    onSelected: (value) => viewModel.setPostType(value),
                  ),

                  Divider(color: Colors.black.withOpacity(0.2)),

                  // 게시풀 - 전체
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: viewModel.posts.length,
                      itemBuilder: (context, index) {
                        final postItem = viewModel.posts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SizedBox(
                            width: screenWidth * 0.85,
                            child: PostCard(recentPost: postItem),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
