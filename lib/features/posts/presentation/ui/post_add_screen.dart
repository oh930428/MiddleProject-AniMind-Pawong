import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/posts_repository.dart';
import '../../domain/entities/breed.dart';
import '../../domain/entities/post_filter_species.dart';
import '../../domain/viewmodel/posts_add_viewmodel.dart';

class PostAddScreen extends StatelessWidget {
  final HomePost? postItem;

  const PostAddScreen({super.key, this.postItem});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          PostsAddViewModel(context.read<PostsRepository>(), postItem),
      child: Consumer<PostsAddViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text(postItem == null ? '게시글 추가' : '게시글 수정')),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await viewModel.savePost(context);
                context.go("/posts");
              },
              label: Text(postItem == null ? '저장' : '수정'),
              icon: const Icon(Icons.save),
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildForm(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, PostsAddViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: viewModel.formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            _buildImagePicker(context, viewModel),
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
                    _buildPostTypeRadio(viewModel),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: viewModel.titleController,
                      labelText: '제목',
                      icon: Icons.note,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: viewModel.contentController,
                      labelText: '내용',
                      icon: Icons.note,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 16),
                    _buildSpeciesDropdown(context, viewModel),
                    const SizedBox(height: 16),
                    _buildBreedsDropdown(context, viewModel),
                    const SizedBox(height: 16),
                    _buildGenderRadio(viewModel),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: viewModel.birthController,
                      labelText: '생일 (YYYY-MM-DD)',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => viewModel.selectDate(
                        context,
                        viewModel.birthController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: viewModel.weightController,
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
    );
  }

  Widget _buildImagePicker(BuildContext context, PostsAddViewModel viewModel) {
    ImageProvider? imageProvider;
    if (viewModel.pickedImage != null) {
      imageProvider = FileImage(viewModel.pickedImage!);
    } else if (viewModel.imageUrl != null && viewModel.imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(viewModel.imageUrl!);
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
            onPressed: () => viewModel.pickImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildPostTypeRadio(PostsAddViewModel viewModel) {
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
                groupValue: viewModel.selectedPostType,
                onChanged: (value) => viewModel.setSelectedPostType(value),
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Q&A'),
                value: 'Q&A',
                groupValue: viewModel.selectedPostType,
                onChanged: (value) => viewModel.setSelectedPostType(value),
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesDropdown(
    BuildContext context,
    PostsAddViewModel viewModel,
  ) {
    return DropdownButtonFormField<PostFilterSpecies>(
      value: viewModel.selectedSpeciesObject,
      items: viewModel.speciesList.map((species) {
        return DropdownMenuItem<PostFilterSpecies>(
          value: species,
          child: Text(species.speciesName),
        );
      }).toList(),
      onChanged: (value) => viewModel.setSelectedSpecies(value),
      decoration: _inputDecoration('종', Icons.category),
      validator: (value) => value == null ? '종을 선택해주세요.' : null,
    );
  }

  Widget _buildBreedsDropdown(
    BuildContext context,
    PostsAddViewModel viewModel,
  ) {
    return DropdownButtonFormField<Breed>(
      value: viewModel.selectedBreedObject,
      items: viewModel.breedsList.map((breed) {
        return DropdownMenuItem<Breed>(value: breed, child: Text(breed.name));
      }).toList(),
      onChanged: (value) => viewModel.setSelectedBreed(value),
      decoration: _inputDecoration('품종', Icons.star),
      validator: (value) => value == null ? '품종을 선택해주세요.' : null,
    );
  }

  Widget _buildGenderRadio(PostsAddViewModel viewModel) {
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
                groupValue: viewModel.selectedGender,
                onChanged: (value) => viewModel.setSelectedGender(value),
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('여아'),
                value: '여아',
                groupValue: viewModel.selectedGender,
                onChanged: (value) => viewModel.setSelectedGender(value),
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
