import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/home/presentation/widgets/post_card.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pet/domain/entities/hospital_records.dart';
import '../../../pet/domain/entities/pet.dart';
import '../../domain/entities/post_item.dart';
import '../widgets/pet_switcher_tab.dart';
import '../widgets/hospital_card.dart';
import '../widgets/pet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPetIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animind - 홈',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(24.0),
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // 나의 반려동물
                Column(
                  spacing: AppLayout.elementSpacing,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 나의 반려동물 세션 제목
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '나의 반려동물',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: textScaler.scale(18.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // 나의 반려동물 탭
                    PetSwitcherTab(
                      pets: _pets,
                      selectedIndex: selectedPetIndex,
                      onSelect: (index) {
                        setState(() => selectedPetIndex = index);
                      },
                    ),

                    // 반려동물 카드
                    PetCard(pet: _pets[selectedPetIndex]),
                  ],
                ),

                const SizedBox(height: AppLayout.sectionSpacing),

                // 최근 병원기록
                Column(
                  spacing: AppLayout.elementSpacing,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 최근 병원기록 세션 제목
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '최근 병원기록',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: textScaler.scale(18.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // 병원기록 카드
                    SizedBox(
                      height: 100,
                      child: _records.isEmpty
                          ? const Center(child: Text("병원기록이 없습니다."))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _records.length,
                              itemBuilder: (context, index) {
                                final record = _records[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SizedBox(
                                    width: screenWidth * 0.85,
                                    child: HospitalCard(record: record),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),

                const SizedBox(height: AppLayout.sectionSpacing),

                // 내가 작성한 게시글 목록
                Column(
                  spacing: AppLayout.elementSpacing,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 내가 작성한 게시글 세션 제목
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '내가 작성한 글',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: textScaler.scale(18.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // 내가 작성한 게시글 카드
                    SizedBox(
                      height: 560, // 카드 높이
                      child: _postList.isEmpty
                          ? const Center(child: Text("내가 작성한 게시글이 없습니다."))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _postList.length,
                              itemBuilder: (context, index) {
                                final postItem = _postList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final List<Pet> _pets = [
  Pet(
    id: '1',
    name: '레오',
    imageUrl:
        'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=2874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    breed: '골든 리트리버',
    weight: 28.5,
    birthDate: '2021-08-15',
    gender: '수컷',
    isNeutered: false,
    type: '',
    tags: [],
    infoGridData: {},
    records: [],
  ),
  Pet(
    id: '2',
    name: '루나',
    imageUrl:
        'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?q=80&w=2869&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

    breed: '코리안 숏헤어',
    weight: 4.8,
    birthDate: '2022-05-20',
    gender: '암컷',
    type: '',
    tags: [],
    infoGridData: {},
    records: [],
    isNeutered: false,
  ),
  Pet(
    id: '3',
    name: '코코',
    imageUrl:
        'https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=2862&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    breed: '푸들',
    weight: 6.2,
    birthDate: '2019-11-11',
    gender: '수컷',
    type: '',
    tags: [],
    infoGridData: {},
    records: [],
    isNeutered: false,
  ),
];

final List<HospitalRecord> _records = [
  HospitalRecord(
    id: 'rec1',
    hospitalName: '',
    title: '',
    visitReason: '정기 검진',
    visitedAt: '2024-10-28',
    nextVisitAt: '2025-04-28',
    memo: '건강 양호, 체중 관리 필요, 약 제시간에 먹여야함',
  ),
  HospitalRecord(
    id: 'rec2',
    hospitalName: '',
    title: '',
    visitReason: '예방 접종',
    visitedAt: '2024-08-15',
    nextVisitAt: '2025-04-28',
    memo: '종합 백신 4차 완료',
  ),
  HospitalRecord(
    id: 'rec3',
    hospitalName: '',
    title: '',
    visitReason: '피부병 검사',
    visitedAt: '2024-09-20',
    nextVisitAt: '2025-04-28',
    memo: '알레르기성 피부염 진단',
  ),
];

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
