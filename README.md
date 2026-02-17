# 🍳 Recipe Finder

A stunning, feature-rich Flutter application for discovering delicious recipes from around the world. Built with a premium UI/UX, real-time search, and local persistence.

---

## ✨ Features

- **🔍 Smart Search**: Instantly find recipes by name, ingredient, or cuisine.
- **🥗 Advanced Filters**: Filter recipes by diet (Vegan, Keto, etc.), preparation time, and intolerances.
- **❤️ Favorites**: Save your favorite recipes locally to access them anytime.
- **📖 Detailed View**: Deep dive into recipe information, including preparation time, health scores, and full instructions.
- **🎨 Premium UI**: Smooth animations powered by `flutter_animate` and a modern aesthetic with `google_fonts`.
- **💾 Offline Support**: Favorite recipes are stored securely using Hive for lightning-fast retrieval.

## 🚀 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Database**: [Hive](https://pub.dev/packages/hive)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)
- **Networking**: [http](https://pub.dev/packages/http)
- **Images**: [cached_network_image](https://pub.dev/packages/cached_network_image)
- **API**: [Spoonacular API](https://spoonacular.com/food-api)

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (>= 3.11.0)
- A Spoonacular API Key

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/recipe_finder.git
    cd recipe_finder
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Setup API Key**:
    Open `lib/services/recipe_service.dart` and replace the `apiKey` with your own:
    ```dart
    final String apiKey = "YOUR_SPOONACULAR_API_KEY";
    ```

4.  **Run the application**:
    ```bash
    flutter run
    ```

## 📂 Project Structure

```text
lib/
├── models/      # Data models (Recipe, etc.)
├── providers/   # State management (RecipeProvider)
├── screens/     # UI screens (Home, Details, Favorites)
├── services/    # API and Database logic
└── widgets/     # Reusable UI components
```
