import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:recipe_finder/providers/recipe_provider.dart';
import 'package:recipe_finder/screens/saved_recipes_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_finder/widgets/recipe_card.dart';

class RecipeLandingPage extends StatefulWidget {
  const RecipeLandingPage({super.key});

  @override
  State<RecipeLandingPage> createState() => _RecipeLandingPageState();
}

class _RecipeLandingPageState extends State<RecipeLandingPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RecipeProvider>();
      _searchController.text = provider.searchQuery;
      // Initial search if empty? standard behavior is fine
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Section
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedRecipesScreen()),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2000&auto=format&fit=crop",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discover Recipes\nfor Every Lifestyle",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Search & Filter Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Centered Search Bar
                  Container(
                    width: screenWidth > 600 ? 500 : double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Color(0xFF2D2D2D)),
                      textAlign: TextAlign.center,
                      onChanged: (val) => provider.updateSearchQuery(val),
                      onSubmitted: (_) => provider.searchRecipes(),
                      decoration: InputDecoration(
                        hintText: "Search recipes...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.search, color: Color(0xFF88A070)),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9,0.9), end: const Offset(1,1)),
                  
                  const SizedBox(height: 32),
                  
                  // Simple Pill-shaped Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _MinimalFilterChip(
                          label: "All",
                          isSelected: provider.selectedDiet == "All",
                          color: const Color(0xFFE8F5E9),
                          selectedColor: const Color(0xFF88A070),
                          onTap: () {
                            provider.updateSelectedDiet("All");
                            provider.searchRecipes();
                          },
                        ),
                        _MinimalFilterChip(
                          label: "Vegetarian",
                          isSelected: provider.selectedDiet == "Vegetarian",
                          color: const Color(0xFFE8F5E9),
                          selectedColor: const Color(0xFF88A070),
                          onTap: () {
                            provider.updateSelectedDiet("Vegetarian");
                            provider.searchRecipes();
                          },
                        ),
                        _MinimalFilterChip(
                          label: "Quick Meals <30min",
                          isSelected: provider.selectedDiet == "Quick Meals <30min",
                          color: const Color(0xFFFFF3E0),
                          selectedColor: const Color(0xFFDFA06E),
                          onTap: () {
                            provider.updateSelectedDiet("Quick Meals <30min");
                            provider.searchRecipes();
                          },
                        ),
                        _MinimalFilterChip(
                          label: "Gluten Free",
                          isSelected: provider.selectedDiet == "Gluten Free",
                          color: const Color(0xFFE3F2FD),
                          selectedColor: const Color(0xFF64B5F6),
                          onTap: () {
                            provider.updateSelectedDiet("Gluten Free");
                            provider.searchRecipes();
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),
          ),
          
          if (provider.loading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                ),
              ),
            )
          else if (provider.error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu_rounded, size: 60, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => provider.searchRecipes(),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final recipe = provider.recipes[index];
                    return RecipeCard(
                      id: recipe.id,
                      title: recipe.title,
                      imageUrl: recipe.image,
                      duration: recipe.duration ?? '?',
                      rating: recipe.rating ?? '?',
                      isSaved: provider.isSaved(recipe.id),
                      onFavoriteToggle: () => provider.toggleFavorite(recipe),
                    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
                  },
                  childCount: provider.recipes.length,
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _MinimalFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final Color selectedColor;
  final VoidCallback onTap;

  const _MinimalFilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : selectedColor,
          ),
        ),
      ),
    );
  }
}
