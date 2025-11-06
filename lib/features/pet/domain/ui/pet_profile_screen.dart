import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/hospital_record_screen.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/pet_edit_screen.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/setting_screen.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/utils.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/widgets/hospital_record_item.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/widgets/info_grid_card.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/widgets/pet_switcher_tab.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/widgets/profile_card.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/widgets/profile_section_header.dart';

import '../entities/pet_data.dart';

// 반려동물 프로필을 보여주는 메인 화면
class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final PetRepository _repo = PetRepository();
  late List<Pet> _allPets;
  Pet? _selectedPet;

  @override
  void initState() {
    super.initState();
    // 저장소에서 모든 반려동물 목록을 가져옴
    _allPets = _repo.getAllPets();
    // 첫 번째 반려동물을 선택된 반려동물로 설정
    _selectedPet = _allPets.isNotEmpty ? _allPets.first : null;
  }

  // 다른 반려동물을 선택했을 때 호출되는 함수
  void _onPetSelected(Pet pet) {
    if (_selectedPet?.id != pet.id) {
      setState(() {
        _selectedPet = pet;
      });
    }
  }

  // 반려동물 추가/수정 화면으로 이동하는 함수
  void _navigateToAddEditScreen(Pet? pet) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PetEditScreen(pet: pet)));

    // 추가/수정 화면에서 반려동물 정보가 반환되었을 경우
    if (result != null && result is Pet) {
      setState(() {
        if (pet == null) {
          // 새로운 반려동물 추가
          _repo.addPet(result);
          _selectedPet = result;
        } else {
          // 기존 반려동물 정보 수정
          _repo.updatePet(result);
          _selectedPet = result;
        }
        // 반려동물 목록을 다시 가져옴
        _allPets = _repo.getAllPets();
      });
    }
  }

  // 병원 기록 화면으로 이동하는 함수
  void _navigateToRecordScreen(Pet pet) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HospitalRecordScreen(pet: pet)),
    );
    // 화면 복귀 시 상태를 갱신
    setState(() {});
  }

  // 반려동물 정보 삭제 확인 다이얼로그를 보여주는 함수
  void _showDeleteConfirmationDialog() {
    if (_selectedPet == null) return;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정보 삭제 확인'),
          content: Text('${_selectedPet!.name}의 모든 정보를 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final petName = _selectedPet!.name;
                // 저장소에서 반려동물 정보 삭제
                _repo.deletePet(_selectedPet!.id);
                setState(() {
                  // 반려동물 목록을 다시 가져오고 선택된 반려동물을 갱신
                  _allPets = _repo.getAllPets();
                  _selectedPet = _allPets.isNotEmpty ? _allPets.first : null;
                });
                Navigator.of(context).pop();
                // 삭제 완료 스낵바 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$petName 정보가 삭제되었습니다.'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                '삭제',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    // 선택된 반려동물의 병원 기록을 가져옴
    final records = _selectedPet != null
        ? _repo.getHospitalRecords(_selectedPet!.id)
        : [];

    return Scaffold(
      backgroundColor: PetColors.lightGrey,
      appBar: AppBar(
        title: Text(
          '반려동물 프로필',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(20.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
          tooltip: '뒤로가기',
        ),
        actions: [
          // 프로필 수정 버튼
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _selectedPet != null
                ? () => _navigateToAddEditScreen(_selectedPet)
                : null,
            tooltip: '프로필 수정',
          ),
          // 설정 화면으로 이동 버튼
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            tooltip: '설정',
          ),
        ],
      ),
      body: SafeArea(
        child: _selectedPet == null
            // 등록된 반려동물이 없을 경우
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('등록된 반려동물이 없습니다.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _navigateToAddEditScreen(null),
                      child: const Text('첫 반려동물 추가하기'),
                    ),
                  ],
                ),
              )
            // 등록된 반려동물이 있을 경우
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    // 반려동물 전환 탭
                    PetSwitcherTab(
                      pets: _allPets,
                      selectedPet: _selectedPet!,
                      onPetSelected: _onPetSelected,
                      onAddPet: () => _navigateToAddEditScreen(null),
                    ),
                    const SizedBox(height: AppLayout.sectionSpacing),
                    // 프로필 카드
                    ProfileCard(pet: _selectedPet!),
                    const SizedBox(height: AppLayout.sectionSpacing),
                    // 상세 정보 그리드
                    InfoGridCard(data: _selectedPet!.infoGridData),
                    const SizedBox(height: AppLayout.sectionSpacing),
                    // 정보 삭제 버튼
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppLayout.horizontalPadding,
                      ),
                      child: OutlinedButton.icon(
                        onPressed: _showDeleteConfirmationDialog,
                        icon: Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                        ),
                        label: Text(
                          '반려동물 정보 삭제',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            AppLayout.minTouchTarget,
                          ),
                          backgroundColor: PetColors.cardBackground,
                          side: const BorderSide(color: PetColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppLayout.cardRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppLayout.sectionSpacing),
                    // 병원 기록 섹션 헤더
                    ProfileSectionHeader(
                      title: '병원 기록',
                      onManagePressed: () =>
                          _navigateToRecordScreen(_selectedPet!),
                    ),
                    const SizedBox(height: AppLayout.elementSpacing),
                    // 병원 기록 목록
                    if (records.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppLayout.horizontalPadding,
                        ),
                        child: Column(
                          children: records
                              .map(
                                (record) => HospitalRecordItem(record: record),
                              )
                              .toList(),
                        ),
                      )
                    else
                      // 병원 기록이 없을 경우
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('등록된 병원 기록이 없습니다.'),
                        ),
                      ),
                    const SizedBox(height: AppLayout.sectionSpacing * 2),
                  ],
                ),
              ),
      ),
    );
  }
}
