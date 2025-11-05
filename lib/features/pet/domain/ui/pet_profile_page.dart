import 'dart:math';

import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/custom_bottom_navbar.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/hospital_record_page.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/ui/setting_page.dart';

// --- Models and Dummy Data ---

class Pet {
  final String id;

  final String name;

  final String imageUrl;

  final String age;

  final String species;

  final String breed;

  final double weight;

  final String birthday;
  final String gender;

  Pet({
    required this.id,

    required this.name,

    required this.imageUrl,

    required this.age,

    required this.species,

    required this.breed,

    required this.weight,

    required this.birthday,
    required this.gender,
  });

  List<Map<String, String>> get infoGridData => [
    {'label': '나이', 'value': age},

    {'label': '성별', 'value': gender},

    {'label': '생일', 'value': birthday},

    {'label': '체중', 'value': '$weight kg'},
  ];
}

class HospitalRecord {
  final String id;

  final String visitDate;

  final String visitReason;

  final String? nextVisitDate;

  final String memo;

  HospitalRecord({
    required this.id,
    required this.visitDate,
    required this.visitReason,
    this.nextVisitDate,
    required this.memo,
  });
}

class PetRepository {
  static final PetRepository _instance = PetRepository._internal();

  factory PetRepository() {
    return _instance;
  }

  PetRepository._internal();

  final List<Pet> _pets = [
    Pet(
      id: '1',

      name: '레오',

      imageUrl:
          'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=2874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

      age: '3살',

      species: '강아지',

      breed: '골든 리트리버',

      weight: 28.5,

      birthday: '2021-08-15',
      gender: '수컷',
    ),

    Pet(
      id: '2',

      name: '루나',

      imageUrl:
          'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?q=80&w=2869&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

      age: '2살',

      species: '고양이',

      breed: '코리안 숏헤어',

      weight: 4.8,

      birthday: '2022-05-20',
      gender: '암컷',
    ),

    Pet(
      id: '3',

      name: '코코',

      imageUrl:
          'https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=2862&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

      age: '5살',

      species: '강아지',

      breed: '푸들',

      weight: 6.2,

      birthday: '2019-11-11',
      gender: '수컷',
    ),
  ];

  final Map<String, List<HospitalRecord>> _records = {
    '1': [
      HospitalRecord(
        id: 'rec1',
        visitDate: '2024-10-28',
        visitReason: '정기 검진',
        memo: '건강 양호, 체중 관리 필요',
        nextVisitDate: '2025-04-28',
      ),

      HospitalRecord(
        id: 'rec2',
        visitDate: '2024-08-15',
        visitReason: '예방 접종',
        memo: '종합 백신 4차 완료',
      ),
    ],

    '2': [
      HospitalRecord(
        id: 'rec3',
        visitDate: '2024-09-20',
        visitReason: '피부병 검사',
        memo: '알레르기성 피부염 진단',
      ),
    ],

    '3': [],
  };

  List<Pet> getAllPets() => _pets;
  List<HospitalRecord> getHospitalRecords(String petId) =>
      _records[petId] ?? [];

  void addPet(Pet pet) {
    _pets.add(pet);
  }

  void updatePet(Pet pet) {
    final index = _pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _pets[index] = pet;
    }
  }

  void deletePet(String petId) {
    _pets.removeWhere((p) => p.id == petId);
  }

  void addHospitalRecord(String petId, HospitalRecord record) {
    if (_records.containsKey(petId)) {
      _records[petId]!.add(record);
    } else {
      _records[petId] = [record];
    }
  }

  void updateHospitalRecord(String petId, HospitalRecord record) {
    if (_records.containsKey(petId)) {
      final index = _records[petId]!.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _records[petId]![index] = record;
      }
    }
  }

  void deleteHospitalRecord(String petId, String recordId) {
    if (_records.containsKey(petId)) {
      _records[petId]!.removeWhere((r) => r.id == recordId);
    }
  }
}

// --- App Constants ---

class AppLayout {
  static const double horizontalPadding = 20.0;
  static const double sectionSpacing = 28.0;
  static const double elementSpacing = 12.0;
  static const double cardRadius = 16.0;
  static const double minTouchTarget = 48.0;
}

class PetColors {
  static const Color border = Color(0xFFE0E0E0);
  static const Color cardBackground = Colors.white;
  static const Color primary = Color(0xFF6200EE);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF757575);
}

// --- Main Screen ---

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final PetRepository _repo = PetRepository();
  late List<Pet> _allPets;
  Pet? _selectedPet;
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _allPets = _repo.getAllPets();
    _selectedPet = _allPets.isNotEmpty ? _allPets.first : null;
  }

  void _onPetSelected(Pet pet) {
    if (_selectedPet?.id != pet.id) {
      setState(() {
        _selectedPet = pet;
      });
    }
  }

  void _navigateToAddEditScreen(Pet? pet) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PetEditScreen(pet: pet)));

    if (result != null && result is Pet) {
      setState(() {
        if (pet == null) {
          // Add
          _repo.addPet(result);
          _selectedPet = result;
        } else {
          // Edit
          _repo.updatePet(result);
          _selectedPet = result;
        }
        _allPets = _repo.getAllPets();
      });
    }
  }

  void _navigateToRecordScreen(Pet pet) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HospitalRecordScreen(pet: pet)),
    );
    setState(() {});
  }

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
                _repo.deletePet(_selectedPet!.id);
                setState(() {
                  _allPets = _repo.getAllPets();
                  _selectedPet = _allPets.isNotEmpty ? _allPets.first : null;
                });
                Navigator.of(context).pop();
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
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      body: SafeArea(
        child: _selectedPet == null
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
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    PetSwitcherTab(
                      pets: _allPets,
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
                    ProfileSectionHeader(
                      title: '병원 기록',
                      onManagePressed: () =>
                          _navigateToRecordScreen(_selectedPet!),
                    ),
                    const SizedBox(height: AppLayout.elementSpacing),
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

// --- Component Widgets ---

class PetSwitcherTab extends StatelessWidget {
  final List<Pet> pets;
  final Pet selectedPet;
  final ValueChanged<Pet> onPetSelected;
  final VoidCallback onAddPet;

  const PetSwitcherTab({
    super.key,
    required this.pets,
    required this.selectedPet,
    required this.onPetSelected,
    required this.onAddPet,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...pets.map((pet) {
                final isSelected = pet.id == selectedPet.id;
                return GestureDetector(
                  onTap: () => onPetSelected(pet),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PetColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      pet.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: onAddPet,
                tooltip: '반려동물 추가',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Pet pet;

  const ProfileCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PetColors.cardBackground,
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: PetColors.lightGrey,
            child: ClipOval(
              child: Image.network(
                pet.imageUrl,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.pets, size: 40, color: Colors.grey);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${pet.species} / ${pet.breed}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: PetColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoGridCard extends StatelessWidget {
  final List<Map<String, String>> data;

  const InfoGridCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PetColors.cardBackground,
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        border: Border.all(color: PetColors.border, width: 1),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['label']!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: PetColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                item['value']!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onManagePressed;

  const ProfileSectionHeader({
    super.key,
    required this.title,
    required this.onManagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(onPressed: onManagePressed, child: const Text('관리하기')),
        ],
      ),
    );
  }
}

class HospitalRecordItem extends StatelessWidget {
  final HospitalRecord record;

  const HospitalRecordItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        side: const BorderSide(color: PetColors.border, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: AppLayout.elementSpacing),
      child: ListTile(
        leading: const Icon(
          Icons.local_hospital_outlined,
          color: PetColors.primary,
        ),
        title: Text(
          record.visitReason,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.memo),
            if (record.nextVisitDate != null &&
                record.nextVisitDate!.isNotEmpty)
              Text(
                '다음 방문: ${record.nextVisitDate}',
                style: TextStyle(
                  color: PetColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        trailing: Text(
          record.visitDate,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

// --- Edit/Add Screen ---

class PetEditScreen extends StatefulWidget {
  final Pet? pet;

  const PetEditScreen({super.key, this.pet});

  @override
  _PetEditScreenState createState() => _PetEditScreenState();
}

class _PetEditScreenState extends State<PetEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  late TextEditingController _speciesController;

  late TextEditingController _breedController;

  late TextEditingController _ageController;

  late TextEditingController _sexController;

  late TextEditingController _birthdayController;

  late TextEditingController _weightController;

  late TextEditingController _imageUrlController;

  String _imageUrl = '';

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.pet?.name ?? '');

    _speciesController = TextEditingController(text: widget.pet?.species ?? '');

    _breedController = TextEditingController(text: widget.pet?.breed ?? '');

    _ageController = TextEditingController(text: widget.pet?.age ?? '');

    _sexController = TextEditingController(text: widget.pet?.gender ?? '');

    _birthdayController = TextEditingController(
      text: widget.pet?.birthday ?? '',
    );

    _weightController = TextEditingController(
      text: widget.pet?.weight.toString() ?? '',
    );

    _imageUrlController = TextEditingController(
      text: widget.pet?.imageUrl ?? '',
    );

    _imageUrl = widget.pet?.imageUrl ?? '';

    _imageUrlController.addListener(() {
      setState(() {
        _imageUrl = _imageUrlController.text;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();

    _speciesController.dispose();

    _breedController.dispose();

    _ageController.dispose();

    _sexController.dispose();

    _birthdayController.dispose();

    _weightController.dispose();

    _imageUrlController.dispose();

    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newPet = Pet(
        id: widget.pet?.id ?? Random().nextInt(10000).toString(),

        name: _nameController.text,

        species: _speciesController.text,

        breed: _breedController.text,

        age: _ageController.text,

        gender: _sexController.text,

        birthday: _birthdayController.text,

        weight: double.tryParse(_weightController.text) ?? 0.0,

        imageUrl: _imageUrlController.text,
      );

      Navigator.of(context).pop(newPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetColors.lightGrey,

      appBar: AppBar(title: Text(widget.pet == null ? '반려동물 추가' : '프로필 수정')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSave,

        label: const Text('저장'),

        icon: const Icon(Icons.save),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 60,

                backgroundColor: PetColors.border,

                backgroundImage: _imageUrl.isNotEmpty
                    ? NetworkImage(_imageUrl)
                    : null,

                onBackgroundImageError: _imageUrl.isNotEmpty ? (e, s) {} : null,

                child: _imageUrl.isEmpty
                    ? const Icon(Icons.pets, size: 60, color: Colors.white)
                    : null,
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 2,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppLayout.cardRadius),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _nameController,

                        labelText: '이름',

                        icon: Icons.pets,
                      ),

                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _speciesController,

                        labelText: '종',

                        icon: Icons.category,
                      ),

                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _breedController,

                        labelText: '품종',

                        icon: Icons.star,
                      ),

                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _ageController,

                        labelText: '나이',

                        icon: Icons.cake,
                      ),

                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _sexController,

                        labelText: '성별',

                        icon: Icons.wc,
                      ),

                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _birthdayController,

                        labelText: '생일',

                        icon: Icons.calendar_today,
                      ),

                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _weightController,

                        labelText: '체중 (kg)',

                        icon: Icons.monitor_weight,

                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _imageUrlController,

                        labelText: '이미지 URL',

                        icon: Icons.image,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: PetColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PetColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText 항목을 입력해주세요.';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return '유효한 숫자를 입력해주세요.';
        }
        return null;
      },
    );
  }
}
