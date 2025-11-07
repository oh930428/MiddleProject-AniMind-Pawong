import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FAQ {
  final String category;
  final String question;
  final String answer;

  FAQ({required this.category, required this.question, required this.answer});
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FaqScreen> {
  String selectedCategory = '전체';
  int? expandedIndex;
  String searchQuery = '';

  final List<FAQ> faqs = [
    FAQ(
      category: '서비스 이용',
      question: '앱은 이떻게 사용하나요?',
      answer:
          '회원가입 후 반려동물을 등록하면 건강 기록 관리, 커뮤니티 참여 등 다양한 기능을 이용하실 수 있습니다. 홈 화면에서 반려동물 정보를 확인하고, 달력 메뉴에서 다른 반려인들과 소통 해보세요.',
    ),
    FAQ(category: '서비스 이용', question: '무료로 이용할 수 있나요?', answer: '무료입니다.'),
    FAQ(
      category: '반려동물 등록',
      question: '반려동물은 몇 마리까지 등록할 수 있나요?',
      answer: '무제한입니다.',
    ),
    FAQ(
      category: '반려동물 등록',
      question: '반려동물 정보를 수정하려면 어떻게 하나요?',
      answer: '수정을 누르세요.',
    ),
  ];

  List<FAQ> get filteredFAQs {
    if (searchQuery.isNotEmpty) {
      return faqs.where((faq) {
        return (faq.question.contains(searchQuery) ||
            faq.answer.contains(searchQuery));
      }).toList();
    }

    if (selectedCategory == '전체') {
      return faqs;
    }
    return faqs.where((faq) => faq.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, //Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background, //Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          '자주 묻는 질문',
          style: TextStyle(
            color: AppColors.textPrimary, //Colors.black,
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
                color: AppColors.textSecondary, //Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                    expandedIndex = null;
                  });
                },
                decoration: InputDecoration(
                  hintText: '궁금한 내용을 검색해보세요',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
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
              child: Row(
                children: [
                  _buildCategoryButton('전체'),
                  const SizedBox(width: 10),
                  _buildCategoryButton('서비스 이용'),
                  const SizedBox(width: 10),
                  _buildCategoryButton('반려동물 등록'),
                ],
              ),
            ),

          const SizedBox(height: 8),

          Container(height: 8, color: Colors.black),

          Expanded(
            child: filteredFAQs.isEmpty
                ? Center(
                    child: Text(
                      '검색 결과가 없습니다',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: filteredFAQs.length,
                    itemBuilder: (context, index) {
                      final faq = filteredFAQs[index];
                      final isExpanded = expandedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .primary, //const Color(0xFF4A7C59),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Q',
                                          style: TextStyle(
                                            color: AppColors
                                                .textPrimary, //Colors.white,
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
                                          color: AppColors
                                              .textPrimary, //Colors.black,
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
                                if (isExpanded) const SizedBox(height: 16),
                                if (isExpanded)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .primaryContainer, //const Color(0xFFFFF9E6),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'A',
                                            style: TextStyle(
                                              color: AppColors
                                                  .textSecondary, //Colors.black,
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
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors
                                                .textSecondary, //Colors.grey,
                                            height: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          expandedIndex = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors
                    .primaryContainer, //const Color(0xFF4A7C59) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.border
                : AppColors.border, //const Color(0xFF4A7C59) : Colors.grey,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected
                ? AppColors.textPrimary
                : AppColors.textSecondary, //Colors.white : Colors.grey,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
