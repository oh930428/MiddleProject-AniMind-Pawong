import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../home/presentation/widgets/post_card.dart';
import '../../domain/viewmodel/posts_viewmodel.dart';
import '../widgets/filter_section.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PostsScreen();
  }
}

class _PostsScreen extends StatefulWidget {
  const _PostsScreen({super.key});

  @override
  State<_PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<_PostsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsViewModel>().loadInitialPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "게시글",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(20.0),
            fontWeight: FontWeight.bold,
          ),
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
              final postType = ["전체", "post", "Q&A"];

              return RefreshIndicator(
                onRefresh: () async {
                  await viewModel.loadInitialPosts();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    FilterSection(
                      title: "종 타입",
                      options: species,
                      selectedValue: viewModel.selectedSpecies,
                      onSelected: (value) => viewModel.setSpecies(value),
                    ),

                    Divider(color: Colors.black.withOpacity(0.2)),

                    FilterSection(
                      title: "타입",
                      options: postType,
                      selectedValue: viewModel.selectedPostType,
                      onSelected: (value) => viewModel.setPostType(value),
                    ),

                    Divider(color: Colors.black.withOpacity(0.2)),

                    // 게시글 리스트
                    ...(viewModel.posts.isEmpty
                        ? [
                            SizedBox(
                              height: 460,
                              child: Center(
                                child: const Text(
                                  "게시글이 없습니다",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ]
                        : viewModel.posts
                              .map(
                                (postItem) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: SizedBox(
                                    height: 400,
                                    child: PostCard(recentPost: postItem),
                                  ),
                                ),
                              )
                              .toList()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
