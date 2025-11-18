import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/posts_repository.dart';
import '../../domain/viewmodel/posts_viewmodel.dart';

class PostAddScreen extends StatelessWidget {
  final HomePost? postItem;

  const PostAddScreen({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostsViewModel(context.read<PostsRepository>()),
      child: _PostsBody(postItem: postItem),
    );
  }
}

class _PostsBody extends StatefulWidget {
  final HomePost? postItem;

  const _PostsBody({super.key, required this.postItem});

  @override
  State<_PostsBody> createState() => _PostsBodyState();
}

class _PostsBodyState extends State<_PostsBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _birthController;
  late final TextEditingController _weightController;

  late String _selectedGender = widget.postItem?.gender ?? '남아';
  late String _selectedPostType = widget.postItem?.postType ?? 'post';
  late String _selectedSpecies = widget.postItem?.species ?? '강아지';
  late String _selectedBreeds = widget.postItem?.breeds ?? '진돗개';

  String? _imageUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.postItem?.imageUrl;
    _pickedImage = null;
    _titleController = TextEditingController(
      text: widget.postItem?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.postItem?.content ?? '',
    );
    _birthController = TextEditingController(
      text: widget.postItem?.birth ?? '',
    );
    _weightController = TextEditingController(
      text: widget.postItem?.weight ?? '',
    );
    _selectedGender = widget.postItem?.gender ?? '남아';
    _selectedPostType = widget.postItem?.postType ?? 'post';
    _selectedSpecies = widget.postItem?.species ?? '강아지';
    _selectedBreeds = widget.postItem?.breeds ?? '진돗개';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _birthController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _imageUrl = null; // Clear network image if a new image is picked
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postItem == null ? "게시글 추가" : "게시글 수정"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          final postId = widget.postItem?.id;

          String? finalImageUrl = _imageUrl;
          if (_pickedImage != null) {
            finalImageUrl = await context.read<PostsViewModel>().uploadImage(
              pickedImage: _pickedImage!,
            );
          }

          if (postId == null) {
            await context.read<PostsViewModel>().addPosts(
              postType: _selectedPostType,
              title: _titleController.text,
              content: _contentController.text,
              species: _selectedSpecies,
              breeds: _selectedBreeds,
              gender: _selectedGender,
              birth: _birthController.text,
              weight: _weightController.text,
              imageUrl: finalImageUrl,
            );
          } else {
            await context.read<PostsViewModel>().updatePosts(
              postId: postId.toString(),
              postType: _selectedPostType,
              title: _titleController.text,
              content: _contentController.text,
              species: _selectedSpecies,
              breeds: _selectedBreeds,
              gender: _selectedGender,
              birth: _birthController.text,
              weight: _weightController.text,
              imageUrl: finalImageUrl,
            );
          }
          context.go("/posts");
        },
        label: Text(widget.postItem == null ? "저장" : "수정"),
        icon: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                _buildImagePicker(context),
                const SizedBox(height: 20),
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildPostTypeRadio(),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _titleController,
                          labelText: '제목',
                          icon: Icons.note,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _contentController,
                          labelText: '내용',
                          icon: Icons.note,
                          maxLines: 6,
                        ),
                        const SizedBox(height: 16),
                        _buildSpeciesDropdown(),
                        const SizedBox(height: 16),
                        _buildBreedsDropdown(),
                        const SizedBox(height: 16),
                        _buildGenderRadio(),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _birthController,
                          labelText: '생일 (YYYY-MM-DD)',
                          icon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _selectDate(context, _birthController),
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _weightController,
                          labelText: '몸무게',
                          icon: Icons.monitor_weight,
                          keyboardType: TextInputType.number,
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
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    ImageProvider? imageProvider;
    if (_pickedImage != null) {
      imageProvider = FileImage(_pickedImage!);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(_imageUrl!);
    }
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.border,
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.pets, size: 60, color: Colors.white)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: AppColors.primary),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  Widget _buildPostTypeRadio() {
    return InputDecorator(
      decoration: _inputDecoration(
        '게시글 타입',
        Icons.article,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('게시글'),
                value: 'post',
                groupValue: _selectedPostType,
                onChanged: (value) {
                  setState(() => _selectedPostType = value!);
                },
                dense: true,
                visualDensity: VisualDensity.compact,
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
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSpecies,
      items: const [
        DropdownMenuItem<String>(value: '강아지', child: Text('강아지')),
        DropdownMenuItem<String>(value: '고양이', child: Text('고양이')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedSpecies = value!;
          if (_selectedSpecies == '강아지' &&
              !['진돗개', '리트리버', '시베리안 허스키', '푸들'].contains(_selectedBreeds)) {
            _selectedBreeds = '진돗개';
          } else if (_selectedSpecies == '고양이' &&
              !['코리안 숏헤어', '페르시안', '샴', '러시안 블루'].contains(_selectedBreeds)) {
            _selectedBreeds = '코리안 숏헤어';
          }
        });
      },
      decoration: _inputDecoration('종', Icons.category),
      validator: (value) =>
          value == null || value.isEmpty ? '종을 선택해주세요.' : null,
    );
  }

  Widget _buildBreedsDropdown() {
    List<DropdownMenuItem<String>> breedItems;

    if (_selectedSpecies == '강아지') {
      breedItems = const [
        DropdownMenuItem<String>(value: '진돗개', child: Text('진돗개')),
        DropdownMenuItem<String>(value: '리트리버', child: Text('리트리버')),
        DropdownMenuItem<String>(value: '시베리안 허스키', child: Text('시베리안 허스키')),
        DropdownMenuItem<String>(value: '푸들', child: Text('푸들')),
      ];
    } else if (_selectedSpecies == '고양이') {
      breedItems = const [
        DropdownMenuItem<String>(value: '코리안 숏헤어', child: Text('코리안 숏헤어')),
        DropdownMenuItem<String>(value: '페르시안', child: Text('페르시안')),
        DropdownMenuItem<String>(value: '샴', child: Text('샴')),
        DropdownMenuItem<String>(value: '러시안 블루', child: Text('러시안 블루')),
      ];
    } else {
      breedItems = const [];
    }

    return DropdownButtonFormField<String>(
      value: _selectedBreeds,
      items: breedItems,
      onChanged: (value) {
        setState(() {
          _selectedBreeds = value!;
        });
      },
      decoration: _inputDecoration('품종', Icons.star),
      validator: (value) =>
          value == null || value.isEmpty ? '품종을 선택해주세요.' : null,
    );
  }

  Widget _buildGenderRadio() {
    return InputDecorator(
      decoration: _inputDecoration(
        '성별',
        Icons.wc,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('남아'),
                value: '남아',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() => _selectedGender = value!);
                },
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('여아'),
                value: '여아',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() => _selectedGender = value!);
                },
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
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
      decoration: _inputDecoration(labelText, icon),
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

  InputDecoration _inputDecoration(
    String labelText,
    IconData icon, {
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: AppColors.primary),
      contentPadding: contentPadding,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
