import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/features/pet/widgets/medical_records_item.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/pet.dart';
import '../domain/viewmodel/pet_profile_viewmodel.dart';
import '../widgets/pet_switcher_tab.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_section_header.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetProfileViewModel(),
      child: const _PetProfileView(),
    );
  }
}

// 실제 UI를 구성하는 private 위젯
class _PetProfileView extends StatelessWidget {
  const _PetProfileView();

  void _navigateToAddEditScreen(BuildContext context, Pet? pet) async {
    final viewModel = context.read<PetProfileViewModel>();
    final result = await context.push('/profile/pet_edit', extra: pet);

    if (result != null && result is Map) {
      final Pet petResult = result['pet'];
      final File? imageFile = result['image'];

      try {
        if (pet == null) {
          await viewModel.addPet(petResult, imageFile);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('반려동물이 성공적으로 추가되었습니다.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          await viewModel.updatePet(petResult, imageFile);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('반려동물 정보가 성공적으로 업데이트되었습니다.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류 발생: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    PetProfileViewModel viewModel,
  ) {
    if (viewModel.selectedPet == null) return;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('반려동물 정보 삭제'),
          content: Text(
            '정말 ${viewModel.selectedPet!.name}의 모든 정보를 삭제하시겠습니까? \n 삭제된 정보는 복구할 수 없습니다',
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade700, width: 2),
                foregroundColor: Colors.black,
              ),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                final petName = viewModel.selectedPet!.name;
                await viewModel.deletePet(viewModel.selectedPet!.id!);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$petName 정보가 삭제되었습니다.'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetProfileViewModel>();
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '반려동물 프로필',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(20.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: viewModel.selectedPet != null
                ? () => _navigateToAddEditScreen(context, viewModel.selectedPet)
                : null,
            tooltip: '프로필 수정',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/profile/settings');
            },
            tooltip: '설정',
          ),
        ],
      ),

      body: SafeArea(child: _buildBody(context, viewModel)),
    );
  }

  Widget _buildBody(BuildContext context, PetProfileViewModel viewModel) {
    if (viewModel.isLoading && viewModel.pets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.pets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('등록된 반려동물이 없습니다.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToAddEditScreen(context, null),
              child: const Text('첫 반려동물 추가하기'),
            ),
          ],
        ),
      );
    }

    final selectedPet = viewModel.selectedPet;

    if (selectedPet == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadPets(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.horizontalPadding * 1.5,
                ),
                child: PetSwitcherTab(
                  pets: viewModel.pets,
                  selectedPet: selectedPet,
                  onPetSelected: (pet) => viewModel.selectPet(pet),
                  onAddPet: () => _navigateToAddEditScreen(context, null),
                ),
              ),
            ),
            const SizedBox(height: AppLayout.sectionSpacing),
            ProfileCard(pet: selectedPet),
            const SizedBox(height: AppLayout.sectionSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppLayout.horizontalPadding * 1.5,
              ),
              child: OutlinedButton.icon(
                onPressed: () =>
                    _showDeleteConfirmationDialog(context, viewModel),
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                label: Text(
                  '반려동물 정보 삭제',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppLayout.minTouchTarget),
                  backgroundColor: AppColors.cardBackground,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppLayout.sectionSpacing),
            ProfileSectionHeader(
              title: '병원 기록',
              onManagePressed: () =>
                  context.push('/profile/hospital_record', extra: selectedPet),
            ),
            const SizedBox(height: AppLayout.elementSpacing),
            _buildMedicalRecords(context, viewModel),
            const SizedBox(height: AppLayout.sectionSpacing * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalRecords(
    BuildContext context,
    PetProfileViewModel viewModel,
  ) {
    if (viewModel.isLoading && viewModel.records.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.records.isEmpty) {
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
        children: viewModel.records
            .map((record) => MedicalRecordsItem(record: record))
            .toList(),
      ),
    );
  }
}
