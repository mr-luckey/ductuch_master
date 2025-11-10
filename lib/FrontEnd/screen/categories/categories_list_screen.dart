import 'package:ductuch_master/FrontEnd/screen/categories/category_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/categories/category_data.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Data/data_loaders.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Categories List Screen - displays all category cards
/// Uses the same card design as learn.dart
class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  List<CategoryInfo> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await DataLoader.loadCategories();
    setState(() {
      categories = loadedCategories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            'Categories',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headlineSmall?.fontFamily,
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24 : 20,
            ),
          ),
          actions: [TtsSpeedDropdown()],
        ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth > 500
                    ? 500
                    : constraints.maxWidth,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 500 ? 20 : 16,
                vertical: constraints.maxWidth > 500 ? 30 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  Text(
                    'Content Categories',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    'Explore words by category',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: textColor.withOpacity(0.6),
                      fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: textColor,
                            ),
                          )
                        : ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: isSmallScreen ? 12 : 16,
                                ),
                                child: _buildCategoryCard(
                                  context,
                                  category.name,
                                  category.icon,
                                  category.words,
                                  isSmallScreen,
                                  scheme,
                                  isDark,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    });
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String categoryName,
    IconData icon,
    List<CategoryWord> words,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
        border: Border.all(color: textColor.withOpacity(0.1)),
        color: surfaceColor.withOpacity(0.02),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(
              () => CategoryScreen(categoryName: categoryName, words: words),
            );
          },
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 50 : 60,
                  height: isSmallScreen ? 50 : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: textColor.withOpacity(0.1)),
                    color: primaryColor.withOpacity(0.2),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: isSmallScreen ? 24 : 28,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 16 : 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: Theme.of(context).textTheme.titleMedium?.fontFamily,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${words.length} words',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: textColor.withOpacity(0.6),
                          fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: textColor.withOpacity(0.5),
                  size: isSmallScreen ? 16 : 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
