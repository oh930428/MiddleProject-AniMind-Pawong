import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';

import '../../../home/domain/entities/post_item.dart';
import '../../../home/presentation/widgets/post_card.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animind - 게시글',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(24.0),
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              // TODO: ListView.Builder로 전환 필요 => API 연결 시
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "종",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(
                          "전체",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Chip(
                        label: Text(
                          "강아지",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.primaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Chip(
                        label: Text(
                          "고양이",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.primaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.black.withOpacity(0.2), height: 2),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "타입",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(
                          "전체",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Color(0xFFD7CEFF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Chip(
                        label: Text(
                          "게시글",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.primaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Chip(
                        label: Text(
                          "Q&A",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.primaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.black.withOpacity(0.2), height: 2),
                ],
              ),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _postList.length,
                  itemBuilder: (context, index) {
                    final postItem = _postList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: SizedBox(
                        width: screenWidth * 0.85,
                        child: PostCard(postItem: postItem),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/posts/add"),
        child: const Icon(Icons.add),
      ),
    );
  }
}

final List<PostItem> _postList = [
  PostItem(
    id: "1",
    user_id: "1",
    post_type: "post",
    title: "첫번째 예시",
    content: "첫번째 예시로 사용할려고 만드는겁니다.",
    species: "강아지",
    breeds: "리트리버",
    gender: "수컷",
    birth: "2025.05.05",
    weight: "6.45",
    image_url:
        "https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=2862&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    created_at: "2025.11.06",
  ),
  PostItem(
    id: "2",
    user_id: "1",
    post_type: "Q&A",
    title: "두번째 예시",
    content: "두번째 예시로 사용할려고 만드는겁니다.",
    species: "강아지",
    breeds: "말티즈",
    gender: "암컷",
    birth: "2022.03.05",
    weight: "4.15",
    image_url:
        "https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=2862&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    created_at: "2025.11.07",
  ),
  PostItem(
    id: "3",
    user_id: "1",
    post_type: "post",
    title: "세번째 예시",
    content: "세번째 예시로 사용할려고 만드는겁니다.",
    species: "고양이",
    breeds: "러시안블루",
    gender: "수컷",
    birth: "2020.04.05",
    weight: "3.12",
    image_url:
        "https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=2862&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    created_at: "2025.11.08",
  ),
  PostItem(
    id: "4",
    user_id: "1",
    post_type: "Q&A",
    title: "네번째 예시",
    content: "네번째 예시로 사용할려고 만드는겁니다.",
    species: "강아지",
    breeds: "시베리안 허스키",
    gender: "암컷",
    birth: "2024.05.05",
    weight: "10.12",
    image_url:
        "https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=2862&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    created_at: "2025.11.09",
  ),
];
