import 'package:ductuch_master/FrontEnd/screen/categories/category_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/categories/category_data.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Data/data_loaders.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:ductuch_master/Utilities/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen>
    with SingleTickerProviderStateMixin {
  List<CategoryInfo> categories = [];
  bool isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: ThemeService.slowAnimationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _loadCategories();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await DataLoader.loadCategories();
    setState(() {
      categories = loadedCategories;
      isLoading = false;
    });
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;

      return Scaffold(
        backgroundColor: backgroundColor,

        // appBar: AppBar(
        //   backgroundColor: backgroundColor,
        //   elevation: 0,
        //   title: Hero(
        //     tag: 'categories_title',
        //     child: Material(
        //       color: Colors.transparent,
        //       child: Text(
        //         'Categories',
        //         style: themeService.getTitleLargeStyle(color: textColor)
        //             .copyWith(
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        //   actions: [const TtsSpeedDropdown()],
        // ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
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
                      // Animated header
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: ThemeService.defaultAnimationDuration,
                        curve: ThemeService.springCurve,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [textColor, primaryColor],
                                    ).createShader(bounds),
                                    child: Text(
                                      'Content Categories',
                                      style: themeService
                                          .getHeadlineSmallStyle(
                                            color: Colors.white,
                                          )
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: isSmallScreen ? 8 : 12),
                                  Text(
                                    'Explore words by category',
                                    style: themeService.getBodyMediumStyle(
                                      color: textColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 24),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
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
                                      index,
                                      themeService,
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
    int index,
    ThemeService themeService,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: ThemeService.springCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    surfaceColor.withOpacity(0.05),
                    surfaceColor.withOpacity(0.02),
                  ],
                ),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    NavigationHelper.pushWithBottomNav(
                      context,
                      CategoryScreen(categoryName: categoryName, words: words),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: primaryColor.withOpacity(0.2),
                  highlightColor: primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    child: Row(
                      children: [
                        // Animated Icon Container
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: ThemeService.defaultAnimationDuration,
                          curve: ThemeService.bounceCurve,
                          builder: (context, iconValue, child) {
                            return Transform.scale(
                              scale: iconValue,
                              child: Container(
                                width: isSmallScreen ? 56 : 64,
                                height: isSmallScreen ? 56 : 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.3),
                                      secondaryColor.withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: primaryColor.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  icon,
                                  color: primaryColor,
                                  size: isSmallScreen ? 28 : 32,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: isSmallScreen ? 16 : 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: themeService
                                    .getTitleMediumStyle(color: textColor)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${words.length} words',
                                style: themeService.getBodySmallStyle(
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor.withOpacity(0.7),
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
