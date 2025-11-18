import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/viewmodel/auth_viewmodel.dart';
import '../../data/repositories/home_repository.dart';
import '../../domain/entities/home_medical_records.dart';
import '../../domain/entities/home_pet.dart';
import '../../domain/entities/home_posts.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widgets/medical_card.dart';
import '../widgets/pet_switcher_tab.dart';
import '../widgets/pet_card.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        context.read<HomeRepository>(),
        context.read<AuthViewModel>().userId ?? "",
      ),
      child: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '홈',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(20.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<HomeViewModel>().loadInitialHome();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<HomeViewModel>(
                builder: (context, viewModel, _) {
                  return Column(
                    children: [
                      _MyPetListSection(pets: viewModel.pets),

                      const SizedBox(height: AppLayout.sectionSpacing),

                      // 최근 병원기록
                      _RecentMedicalRecordsSection(
                        screenWidth: screenWidth,
                        medicalRecords: viewModel.medicalRecords,
                      ),

                      const SizedBox(height: AppLayout.sectionSpacing),

                      // 내가 작성한 게시물
                      _RecentPostListSection(
                        screenWidth: screenWidth,
                        recentPost: viewModel.posts,
                      ),

                      const SizedBox(height: AppLayout.sectionSpacing),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MyPetListSection extends StatefulWidget {
  final List<HomePet> pets;

  const _MyPetListSection({super.key, required this.pets});

  @override
  State<_MyPetListSection> createState() => _MyPetListSectionState();
}

class _MyPetListSectionState extends State<_MyPetListSection> {
  int selectedPetIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pets = widget.pets;

    if (selectedPetIndex >= pets.length) {
      selectedPetIndex = 0;
    }

    return Column(
      children: [
        // 나의 반려동물
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '나의 반려동물',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),

        const SizedBox(height: AppLayout.elementSpacing),

        Column(
          spacing: AppLayout.elementSpacing,
          children: [
            PetSwitcherTab(
              pets: pets,
              selectedIndex: selectedPetIndex,
              onSelect: (index) {
                setState(() => selectedPetIndex = index);
              },
            ),
            pets.isEmpty
                ? Container(
                    constraints: BoxConstraints(minHeight: 120),
                    child: Center(
                      child: Text(
                        "등록된 반려동물이 없습니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : PetCard(pet: pets[selectedPetIndex]),
          ],
        ),
      ],
    );
  }
}

class _RecentMedicalRecordsSection extends StatelessWidget {
  final List<HomeMedicalRecords> medicalRecords;
  final double screenWidth;

  const _RecentMedicalRecordsSection({
    super.key,
    required this.screenWidth,
    required this.medicalRecords,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppLayout.elementSpacing,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 최근 병원기록 세션 제목
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '최근 병원기록',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),

        // 병원기록 카드
        Container(
          constraints: BoxConstraints(minHeight: 120),
          child: medicalRecords.isEmpty
              ? const Center(
                  child: Text(
                    "병원기록이 없습니다.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: medicalRecords.length,
                  itemBuilder: (context, index) {
                    final record = medicalRecords[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: screenWidth * 0.85,
                        child: HomeMedicalCard(record: record),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _RecentPostListSection extends StatelessWidget {
  final List<HomePost> recentPost;
  final double screenWidth;

  const _RecentPostListSection({
    super.key,
    required this.screenWidth,
    required this.recentPost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppLayout.elementSpacing,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 내가 작성한 게시글 세션 제목
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '내가 작성한 글',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),

        // 내가 작성한 게시글 카드
        Container(
          constraints: BoxConstraints(minHeight: 200),
          child: recentPost.isEmpty
              ? const Center(
                  child: Text(
                    "내가 작성한 게시글이 없습니다.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentPost.length,
                  itemBuilder: (context, index) {
                    final _recentPost = recentPost[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: SizedBox(
                        width: screenWidth * 0.85,
                        child: PostCard(recentPost: _recentPost),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
