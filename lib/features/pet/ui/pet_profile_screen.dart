import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';
import 'package:middleproject_animind_pawong/features/pet/data/repogitories/pet_repository.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';
import 'package:middleproject_animind_pawong/features/pet/ui/medical_records_screen.dart';
import 'package:middleproject_animind_pawong/features/pet/ui/pet_edit_screen.dart';
import 'package:middleproject_animind_pawong/features/pet/ui/setting_screen.dart';
import 'package:middleproject_animind_pawong/features/pet/widgets/info_grid_card.dart';
import 'package:middleproject_animind_pawong/features/pet/widgets/medical_records_item.dart';
import 'package:middleproject_animind_pawong/features/pet/widgets/pet_switcher_tab.dart';
import 'package:middleproject_animind_pawong/features/pet/widgets/profile_card.dart';
import 'package:middleproject_animind_pawong/features/pet/widgets/profile_section_header.dart';

// 반려동물 프로필을 보여주는 메인 화면
class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final PetRepository _repo = PetRepository();
  late Future<List<Pet>> _petsFuture;
  Pet? _selectedPet;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() {
    _petsFuture = _repo.getAllPets();
    _petsFuture.then((pets) {
      setState(() {
        _selectedPet = pets.isNotEmpty ? pets.first : null;
      });
    });
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

    if (result != null && result is Pet) {
      if (pet == null) {
        await _repo.addPet(result);
      } else {
        await _repo.updatePet(result);
      }
      _loadPets();
    }
  }

  // 병원 기록 화면으로 이동하는 함수
  void _navigateToRecordScreen(Pet pet) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MedicalRecordsScreen(pet: pet)),
    );
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
              onPressed: () async {
                final petName = _selectedPet!.name;
                await _repo.deletePet(_selectedPet!.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$petName 정보가 삭제되었습니다.'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _loadPets();
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

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
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
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _selectedPet != null
                ? () => _navigateToAddEditScreen(_selectedPet)
                : null,
            tooltip: '프로필 수정',
          ),
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
        child: FutureBuilder<List<Pet>>(
          future: _petsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final allPets = snapshot.data ?? [];

            if (allPets.isEmpty) {
              return Center(
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
              );
            }

            if (_selectedPet == null && allPets.isNotEmpty) {
              _selectedPet = allPets.first;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  PetSwitcherTab(
                    pets: allPets,
                    selectedPet: _selectedPet!,
                    onPetSelected: _onPetSelected,
                    onAddPet: () => _navigateToAddEditScreen(null),
                  ),
                  const SizedBox(height: AppLayout.sectionSpacing),
                  ProfileCard(pet: _selectedPet!),
                  const SizedBox(height: AppLayout.sectionSpacing),
                  InfoGridCard(data: _selectedPet!.infoGridData),
                  const SizedBox(height: AppLayout.sectionSpacing),
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
                        backgroundColor: AppColors.cardBackground,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppLayout.cardRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppLayout.sectionSpacing),
                  ProfileSectionHeader(
                    title: '병원 기록',
                    onManagePressed: () =>
                        _navigateToRecordScreen(_selectedPet!),
                  ),
                  const SizedBox(height: AppLayout.elementSpacing),
                  FutureBuilder<List<MedicalRecords>>(
                    future: _repo.getMedicalRecords(_selectedPet!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final records = snapshot.data ?? [];

                      if (records.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('등록된 병원 기록이 없습니다.'),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppLayout.horizontalPadding,
                        ),
                        child: Column(
                          children: records
                              .map(
                                (record) => MedicalRecordsItem(record: record),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppLayout.sectionSpacing * 2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
