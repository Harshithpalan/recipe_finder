class Recipe {
  final int id;
  final String title;
  final String image;
  final String? duration;
  final String? rating;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    this.duration,
    this.rating,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      duration: json['readyInMinutes']?.toString() ?? '20 min',
      rating: (json['spoonacularScore'] != null) 
          ? (json['spoonacularScore'] / 20).toStringAsFixed(1) 
          : '4.5',
    );
  }

  // Convert to Map for Hive storage without TypeAdapters
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'duration': duration,
      'rating': rating,
    };
  }

  factory Recipe.fromMap(Map<dynamic, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      duration: map['duration'],
      rating: map['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
    };
  }
}
