import 'package:hive/hive.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class RecipeModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String? duration;

  @HiveField(4)
  final String? rating;

  RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    this.duration,
    this.rating,
  });
}
