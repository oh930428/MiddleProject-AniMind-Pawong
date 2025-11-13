import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/features/home/domain/entities/home_posts.dart';
import 'package:middleproject_animind_pawong/features/home/domain/entities/post_item.dart';
import 'package:middleproject_animind_pawong/features/posts/data/repositories/posts_repository.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/viewmodel/posts_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';

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
  late final TextEditingController _imageUrlController;

  late String _selectedGender = widget.postItem?.gender ?? '남아';
  late String _selectedPostType = widget.postItem?.postType ?? 'post';
  late String _selectedSpecies = widget.postItem?.species ?? '강아지';
  late String _selectedBreeds = widget.postItem?.breeds ?? '진돗개';

  String? _imageUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
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
    _imageUrlController = TextEditingController(
      text: widget.postItem?.imageUrl ?? '',
    );
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

  // ImageProvider? _getImageProvider() {
  //   if (_pickedImage != null) {
  //     return FileImage(_pickedImage!);
  //   } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
  //     return NetworkImage(_imageUrl!);
  //   }
  //   return null;
  // }
  //
  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _pickedImage = File(pickedFile.path);
  //       _imageUrl = pickedFile.path;
  //       _imageUrlController.text = pickedFile.path;
  //     });
  //   }
  // }

  ImageProvider? _getImageProvider() {
    if (_pickedImage != null) return FileImage(_pickedImage!);
    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
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
        _imageUrlController.text = "";
      });
    } else {}
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.postItem == null ? "게시글 추가" : "게시글 수정"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final postItem = widget.postItem;

          if (postItem == null) {
            await context.read<PostsViewModel>().addPosts(
              postType: _selectedPostType,
              title: _titleController.text,
              content: _contentController.text,
              species: _selectedSpecies,
              breeds: _selectedBreeds,
              gender: _selectedGender,
              birth: _birthController.text,
              weight: _weightController.text,
              imageUrl: _imageUrlController.text,
            );
          } else {
            await context.read<PostsViewModel>().updatePosts(
              postId: postItem.id.toString(),
              postType: _selectedPostType,
              title: _titleController.text,
              content: _contentController.text,
              species: _selectedSpecies,
              breeds: _selectedBreeds,
              gender: _selectedGender,
              birth: _birthController.text,
              weight: _weightController.text,
              // imageUrl: _imageUrlController.text,
            );
          }
          context.go("/posts");
        },
        label: Text(widget.postItem == null ? "저장" : "수정"),
        icon: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<PostsViewModel>(
            builder: (context, viewModel, _) {
              return SingleChildScrollView(
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
                                    value: 'post',
                                    groupValue: _selectedPostType,
                                    onChanged: (value) {
                                      setState(
                                        () => _selectedPostType = value!,
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('Q&A'),
                                    value: 'Q&A',
                                    groupValue: _selectedPostType,
                                    onChanged: (value) {
                                      setState(
                                        () => _selectedPostType = value!,
                                      );
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
                                    value: '남아',
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      setState(() => _selectedGender = value!);
                                    },
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
                          onTap: () => _selectDate(context, _birthController),
                        ),

                        // 몸무게
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
              );
            },
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
