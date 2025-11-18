import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/posts_repository.dart';
import '../../domain/entities/breed.dart';
import '../../domain/entities/post_filter_species.dart';

class PostsAddViewModel extends ChangeNotifier {
  final PostsRepository _postsRepository;
  final HomePost? postItem;

  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController birthController;
  late final TextEditingController weightController;

  String _selectedGender = '남아';
  String _selectedPostType = 'post';
  PostFilterSpecies? _selectedSpeciesObject;
  Breed? _selectedBreedObject;

  String? _imageUrl;
  File? _pickedImage;
  bool _isLoading = false;

  List<PostFilterSpecies> _speciesList = [];
  List<Breed> _breedsList = [];

  PostsAddViewModel(this._postsRepository, this.postItem) {
    _imageUrl = postItem?.imageUrl;
    titleController = TextEditingController(text: postItem?.title ?? '');
    contentController = TextEditingController(text: postItem?.content ?? '');
    birthController = TextEditingController(text: postItem?.birth ?? '');
    weightController = TextEditingController(text: postItem?.weight ?? '');
    _selectedGender = postItem?.gender ?? '남아';
    _selectedPostType = postItem?.postType ?? 'post';

    _loadInitialData();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    birthController.dispose();
    weightController.dispose();
    super.dispose();
  }

  String get selectedGender => _selectedGender;
  String get selectedPostType => _selectedPostType;
  PostFilterSpecies? get selectedSpeciesObject => _selectedSpeciesObject;
  Breed? get selectedBreedObject => _selectedBreedObject;
  File? get pickedImage => _pickedImage;
  String? get imageUrl => _imageUrl;
  bool get isLoading => _isLoading;
  List<PostFilterSpecies> get speciesList => _speciesList;
  List<Breed> get breedsList => _breedsList;

  void setSelectedGender(String? value) {
    if (value != null) {
      _selectedGender = value;
      notifyListeners();
    }
  }

  void setSelectedPostType(String? value) {
    if (value != null) {
      _selectedPostType = value;
      notifyListeners();
    }
  }

  void setSelectedSpecies(PostFilterSpecies? value) {
    _selectedSpeciesObject = value;
    _selectedBreedObject = null;
    if (value != null) {
      _loadBreeds(value.id);
    } else {
      _breedsList = [];
    }
    notifyListeners();
  }

  void setSelectedBreed(Breed? value) {
    _selectedBreedObject = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      _imageUrl = null;
      notifyListeners();
    }
  }

  Future<void> selectDate(
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

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _speciesList = await _postsRepository.getSpecies();
      if (postItem != null) {
        _selectedSpeciesObject = _speciesList.firstWhere(
          (species) => species.speciesName == postItem!.species,
          orElse: () => _speciesList.first,
        );
        await _loadBreeds(_selectedSpeciesObject!.id);
        _selectedBreedObject = _breedsList.firstWhere(
          (breed) => breed.name == postItem!.breeds,
          orElse: () => _breedsList.first,
        );
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadBreeds(int speciesId) async {
    try {
      _breedsList = await _postsRepository.getBreedsBySpeciesId(speciesId);
    } catch (e) {
      _breedsList = [];
    }
    notifyListeners();
  }

  Future<bool> savePost(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedSpeciesObject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('종을 선택해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_selectedBreedObject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('품종을 선택해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentSession?.user?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 필요합니다.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }

      String? finalImageUrl = _imageUrl;
      if (_pickedImage != null) {
        finalImageUrl = await _postsRepository.uploadImage(
          pickedImage: _pickedImage!,
          userId: userId,
        );
      }

      if (postItem == null) {
        await _postsRepository.addPosts(
          userId: userId,
          postType: _selectedPostType,
          title: titleController.text,
          content: contentController.text,
          gender: _selectedGender,
          birth: birthController.text,
          weight: weightController.text,
          imageUrl: finalImageUrl,
          breedsId: _selectedBreedObject?.id,
        );
      } else {
        await _postsRepository.updatePosts(
          postId: postItem!.id.toString(),
          postType: _selectedPostType,
          title: titleController.text,
          content: contentController.text,
          gender: _selectedGender,
          birth: birthController.text,
          weight: weightController.text,
          imageUrl: finalImageUrl,
          breedsId: _selectedBreedObject?.id,
        );
      }
      return true;
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시글 저장 실패: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
