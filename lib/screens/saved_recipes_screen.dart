import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_finder/models/recipe.dart';
import 'package:recipe_finder/providers/recipe_provider.dart';
import 'package:recipe_finder/widgets/recipe_card.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final savedRecipes = provider.savedRecipes;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Saved Recipes', 
          style: GoogleFonts.poppins(
            color: const Color(0xFF2D2D2D),
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D2D2D), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: savedRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey[200]),
                  const SizedBox(height: 16),
                  Text(
                    'No saved recipes yet',
                    style: GoogleFonts.poppins(
                      fontSize: 16, 
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final model = savedRecipes[index];
                        final recipe = Recipe(
                          id: model.id,
                          title: model.title,
                          image: model.image,
                          duration: model.duration,
                          rating: model.rating,
                        );
                        return RecipeCard(
                          id: model.id,
                          title: recipe.title,
                          imageUrl: recipe.image,
                          duration: recipe.duration!,
                          rating: recipe.rating!,
                          isSaved: true,
                          onFavoriteToggle: () => provider.toggleFavorite(recipe),
                        );
                      },
                      childCount: savedRecipes.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
    );
  }
}
