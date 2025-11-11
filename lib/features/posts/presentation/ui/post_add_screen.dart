import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middleproject_animind_pawong/features/home/domain/entities/post_item.dart';

import '../../../../core/theme/app_colors.dart';

class PostAddScreen extends StatefulWidget {
  final PostItem? postItem;

  const PostAddScreen({super.key, this.postItem});

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _birthController;
  late final TextEditingController _weightController;
  late TextEditingController _imageUrlController;

  String _selectedGender = 'male';
  String _selectedPostType = 'Post';
  String _selectedSpecies = '강아지';
  String _selectedBreeds = '진돗개';

  String? _imageUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _birthController = TextEditingController();
    _weightController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _birthController.dispose();
    _weightController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  ImageProvider? _getImageProvider() {
    if (_pickedImage != null) {
      return FileImage(_pickedImage!);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return NetworkImage(_imageUrl!);
    }
    return null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _imageUrl = null;
        _imageUrlController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.postItem == null ? "게시글 추가" : "게시글 수정"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(widget.postItem == null ? "저장" : "수정"),
        icon: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16,
                  children: [
                    // 이미지
                    Builder(
                      builder: (context) {
                        final imageProvider = _getImageProvider();
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.border,
                              backgroundImage: imageProvider,
                              onBackgroundImageError: imageProvider != null
                                  ? (e, s) {
                                      print('Image load error: $e\n$s');
                                    }
                                  : null,
                              child: imageProvider == null
                                  ? const Icon(
                                      Icons.pets,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.primary,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // 게시글 타입
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "게시글 타입",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('게시글'),
                                value: 'Post',
                                groupValue: _selectedPostType,
                                onChanged: (value) {
                                  setState(() => _selectedPostType = value!);
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Q&A'),
                                value: 'Q&A',
                                groupValue: _selectedPostType,
                                onChanged: (value) {
                                  setState(() => _selectedPostType = value!);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // 제목
                    _buildTextFormField(
                      controller: _titleController,
                      labelText: '제목',
                      icon: Icons.note,
                      maxLines: 3,
                    ),

                    // 내용
                    _buildTextFormField(
                      controller: _contentController,
                      labelText: '내용',
                      icon: Icons.note,
                      maxLines: 6,
                    ),

                    // 종
                    DropdownMenu<String>(
                      width: screenWidth,
                      initialSelection: _selectedSpecies,
                      label: const Text('종 선택'),
                      onSelected: (value) =>
                          setState(() => _selectedSpecies = value!),
                      menuStyle: MenuStyle(
                        alignment: AlignmentDirectional.bottomStart,
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: '강아지',
                          label: '강아지',
                          labelWidget: SizedBox(
                            width: screenWidth * 0.8,
                            child: Text("강아지"),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: '고양이',
                          label: '고양이',
                          labelWidget: SizedBox(
                            width: screenWidth * 0.8,
                            child: Text("고양이"),
                          ),
                        ),
                      ],
                    ),

                    // 품종
                    DropdownMenu<String>(
                      width: screenWidth,
                      initialSelection: _selectedBreeds,
                      label: Text('품종 선택'),
                      onSelected: (value) =>
                          setState(() => _selectedBreeds = value!),
                      menuStyle: MenuStyle(
                        alignment: AlignmentDirectional.bottomStart,
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: '진돗개',
                          label: '진돗개',
                          labelWidget: SizedBox(
                            width: screenWidth * 0.8,
                            child: Text("진돗개"),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: '리트리버',
                          label: '리트리버',
                          labelWidget: SizedBox(
                            width: screenWidth * 0.8,
                            child: Text("리트리버"),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: '시베리안 허스키',
                          label: '시베리안 허스키',
                          labelWidget: SizedBox(
                            width: screenWidth * 0.8,
                            child: Text("시베리안 허스키"),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: '푸들',
                          label: '푸들',
                          labelWidget: SizedBox(
                            width: screenWidth * 0.8,
                            child: Text("푸들"),
                          ),
                        ),
                      ],
                    ),

                    // 셩별
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "성별",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('남아'),
                                value: 'male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value!);
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('여아'),
                                value: 'female',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value!);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // 생일
                    _buildTextFormField(
                      controller: _birthController,
                      labelText: '생일 (YYYY-MM-DD)',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _birthController,
                    ),

                    // 몸무게
                    _buildTextFormField(
                      controller: _weightController,
                      labelText: '몸무게',
                      icon: Icons.monitor_weight,
                      readOnly: true,
                      onTap: () => _weightController,
                    ),
                  ],
                ),
              ),
            ),
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
    bool readOnly = false,
    int? maxLines = 1,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (labelText.contains('(선택)')) {
            return null;
          }
          return '$labelText 항목을 입력해주세요.';
        }
        return null;
      },
    );
  }
}
