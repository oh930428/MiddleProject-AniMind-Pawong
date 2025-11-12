import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/faq.dart';
import '../domain/viewmodel/faq_viewmodel.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqViewModel _viewModel = FaqViewModel();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = '전체';
  int? expandedIndex;
  String searchQuery = '';

  List<FAQ> faqs = [];
  bool isLoading = false;
  bool isLoadingAdditional = false;
  bool hasAdditional = true;
  String? errorMessage;

  Timer? _debounceTimer;
  static const int searchThreshold = 800; //ms

  @override
  void initState() {
    super.initState();
    _loadInitialFAQs();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent -
                FaqViewModel.scrollLoadThreshold &&
        !isLoadingAdditional &&
        hasAdditional) {
      _loadAdditionalFAQs();
    }
  }

  void _onSearchTextChanged() {
    setState(() {}); //xicon

    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: searchThreshold), () {
      final newQuery = _searchController.text.trim();
      if (searchQuery != newQuery) {
        setState(() {
          searchQuery = newQuery;
          expandedIndex = null;
        });
        _loadInitialFAQs();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear(); //_onSearchTextChanged
  }

  Future<void> _loadInitialFAQs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final newFAQs = await _viewModel.fetchInitialFAQs(
        category: selectedCategory == '전체' ? null : selectedCategory,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );

      setState(() {
        faqs = newFAQs;
        hasAdditional = newFAQs.length >= FaqViewModel.initialLoadCount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = '데이터를 불러오는데 실패했습니다. 재시도하세요.';
      });
      _showErrorSnackBar();
    }
  }

  Future<void> _loadAdditionalFAQs() async {
    if (isLoadingAdditional || !hasAdditional) return;

    setState(() {
      isLoadingAdditional = true;
      errorMessage = null;
    });

    try {
      final newFAQs = await _viewModel.fetchAdditionalFAQs(
        offset: faqs.length,
        category: selectedCategory == '전체' ? null : selectedCategory,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );

      setState(() {
        faqs.addAll(newFAQs);
        hasAdditional = newFAQs.length >= FaqViewModel.additionalLoadCount;
        isLoadingAdditional = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAdditional = false;
        errorMessage = '추가 데이터를 불러오는데 실패했습니다. 재시도하세요.';
      });
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
      expandedIndex = null;
    });
    _loadInitialFAQs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          '자주 묻는 질문',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '궁금한 내용을 검색해보세요',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          if (searchQuery.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton('전체'),
                    const SizedBox(width: 10),
                    _buildCategoryButton('계정 및 개인정보'),
                    const SizedBox(width: 10),
                    _buildCategoryButton('반려동물 관리'),
                    const SizedBox(width: 10),
                    _buildCategoryButton('병원 및 진료기록'),
                    const SizedBox(width: 10),
                    _buildCategoryButton('커뮤니티 이용'),
                    const SizedBox(width: 10),
                    _buildCategoryButton('설정 및 고객지원'),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(height: 8, color: Colors.black),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  Widget _buildTable() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (faqs.isEmpty) {
      return const Center(
        child: Text(
          '검색 결과가 없습니다',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(0),
      itemCount: faqs.length + (isLoadingAdditional ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == faqs.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final faq = faqs[index];
        final isExpanded = expandedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      expandedIndex = isExpanded ? null : index;
                    });
                  },
                  splashColor: AppColors.lightGrey,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(11),
                        topRight: Radius.circular(11),
                        bottomLeft: isExpanded
                            ? Radius.zero
                            : Radius.circular(11),
                        bottomRight: isExpanded
                            ? Radius.zero
                            : Radius.circular(11),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              'Q',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            faq.question,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                if (isExpanded)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(11),
                        bottomRight: Radius.circular(11),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            faq.answer,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: AppColors.textSecondary,
                              height: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () => _onCategoryChanged(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
