# 🇩🇪 DeutschMaster

A comprehensive German language learning application built with Flutter, designed to help learners master German from beginner (A1) to advanced (C2) levels.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue)

## 📱 Overview

DeutschMaster is a feature-rich mobile application that provides structured German language learning through interactive lessons, practice exercises, exams, and comprehensive vocabulary management. The app follows the Common European Framework of Reference for Languages (CEFR) standards, covering levels A1 through C2.

## ✨ Features

### 🎓 Learning Modules
- **Structured Learning Path**: Organized modules for each proficiency level (A1, A2, B1, B2, C1, C2)
- **Interactive Lessons**: Engaging lesson content with topics covering:
  - Greetings & Basics
  - People & Family
  - Home & Objects
  - City & Transportation
  - Daily Life & Activities
  - Working Life
  - Media & Opinions
  - Culture & Society
  - And much more!
- **Progress Tracking**: Monitor your learning journey with detailed progress indicators
- **Module Completion**: Track completed modules and lessons across all levels

### 🔊 Text-to-Speech (TTS)
- **Native German Pronunciation**: Built-in TTS with German language support (de-DE)
- **Adjustable Speed**: Control speech rate (0.5x or 0.8x speed options)
- **Interactive Learning**: Tap to hear pronunciation of words and phrases
- **Global Speed Control**: Consistent TTS settings across the entire app

### 🎨 Theme System
- **Dark & Light Modes**: Beautiful themes for comfortable learning in any environment
- **Multiple Color Schemes**: Customizable color palettes
- **Smooth Animations**: Polished UI with fluid transitions and animations
- **Responsive Design**: Optimized for mobile, tablet, and desktop devices

### 📊 Progress & Statistics
- **Overall Progress**: Visual progress bars showing completion percentage
- **Module Statistics**: Track completed modules vs. total modules
- **Time Investment**: Estimated learning time tracking
- **Lesson Completion**: Detailed tracking of completed lessons
- **Next Lesson Suggestions**: Smart recommendations for continuing your learning

### 📝 Exam Mode
- **Level-Based Exams**: Comprehensive exams for A1, A2, B1, and B2 levels
- **150+ Questions**: Extensive question banks for each level
- **Timed Tests**: 
  - A1/A2: 60 minutes
  - B1: 70 minutes
  - B2: 80 minutes
- **Score Tracking**: Detailed results with percentage scores
- **Answer Review**: Review correct answers and explanations after completion
- **Level Certification**: Automatic level passing when scoring 70% or higher

### 🎯 Practice Mode
- **Unlimited Practice**: Practice without time constraints
- **Flexible Learning**: Review and reinforce concepts at your own pace
- **Question Bank**: Access to extensive practice questions

### 📚 Vocabulary Management
- **Nouns Section**: Comprehensive German nouns database
- **Verbs Section**: Extensive verb conjugations and usage
- **Sentences Section**: Common phrases and sentence structures
- **Categories**: Learn vocabulary organized by themes and topics

### 🏆 Levels Overview
- **A1 - Beginner**: Master basic greetings, self-introductions, daily routines
- **A2 - Elementary**: Expand vocabulary and grammar for everyday situations
- **B1 - Intermediate**: Advance with working life, media, and culture topics
- **B2 - Upper Intermediate**: Precision, style, and specialized language
- **C1 - Advanced**: Advanced topics (coming soon)
- **C2 - Mastery**: Mastery level content (coming soon)

### 🎯 Additional Features
- **Categories Learning**: Learn words organized by categories
- **Responsive UI**: Adapts beautifully to different screen sizes
- **Offline Support**: Learn without internet connection
- **Persistent Navigation**: Easy access to all features via bottom navigation
- **Smooth Animations**: Engaging user experience with fluid animations

## 🛠️ Tech Stack

### Core Technologies
- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language (SDK 3.8.1+)

### Key Dependencies
- **GetX**: State management and navigation (`get: ^4.7.2`)
- **Flutter TTS**: Text-to-speech functionality (`flutter_tts: ^4.2.3`)
- **Google Fonts**: Typography (`google_fonts: ^6.3.2`)
- **Shared Preferences**: Local data persistence (`shared_preferences: ^2.2.2`)
- **Persistent Bottom Nav Bar**: Navigation (`persistent_bottom_nav_bar: ^6.2.1`)
- **Flutter SVG**: SVG support (`flutter_svg: ^2.2.1`)

### Architecture
- **MVC Pattern**: Model-View-Controller architecture
- **GetX State Management**: Reactive state management
- **Repository Pattern**: Data layer abstraction
- **Service Layer**: Business logic separation

## 📦 Installation

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ductuch_master.git
   cd ductuch_master
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: Latest
- For Play Store builds, create a `key.properties` file in the project root (never commit it) with:
  ```
  storeFile=/absolute/path/to/your/keystore.jks
  storePassword=your-store-password
  keyAlias=your-key-alias
  keyPassword=your-key-password
  ```
- The Gradle script in `android/app/build.gradle.kts` will automatically load these values when the file exists.

#### iOS
- Minimum iOS version: 12.0
- Configure signing in Xcode

## 📁 Project Structure

```
lib/
├── app_routes.dart              # Application routing configuration
├── main.dart                    # Application entry point
├── backend/
│   ├── data/                    # Data models and learning path data
│   ├── models/                  # Data models
│   ├── repository/              # Data repository layer
│   └── services/                # Business logic services
│       ├── theme_service.dart   # Theme management
│       └── tts_service.dart     # Text-to-speech service
├── Constants/
│   ├── colors.dart              # Color constants
│   └── FontStyle.dart           # Font configuration
├── controllers/
│   └── lesson_controller.dart   # Lesson state management
├── Data/
│   ├── A1/                      # A1 level data
│   ├── A2/                      # A2 level data
│   ├── B1/                      # B1 level data
│   ├── B2/                      # B2 level data
│   ├── C1/                      # C1 level data
│   ├── C2/                      # C2 level data
│   ├── json/                    # JSON data files
│   └── data_loaders.dart        # Data loading utilities
├── FrontEnd/
│   └── screen/
│       ├── A1/                  # A1 lesson screens
│       ├── A2/                  # A2 lesson screens
│       ├── B1/                  # B1 lesson screens
│       ├── B2/                  # B2 lesson screens
│       ├── C1/                  # C1 lesson screens
│       ├── C2/                  # C2 lesson screens
│       ├── Home/                # Home screen
│       ├── learn/               # Learn screen
│       ├── Levels/              # Levels overview
│       ├── level_screen/         # Level selection screen
│       ├── exam/                 # Exam screen
│       ├── practice/             # Practice screen
│       ├── nouns/                # Nouns screen
│       ├── verbs/                # Verbs screen
│       ├── sentences/            # Sentences screen
│       ├── categories/           # Categories screen
│       ├── more/                 # More options screen
│       └── main_navigation.dart  # Main navigation
└── Utilities/
    ├── Models/                   # Utility models
    ├── Widgets/                  # Reusable widgets
    ├── navigation_helper.dart   # Navigation utilities
    ├── responsive_helper.dart   # Responsive design helpers
    └── playphrase.dart          # Phrase playback utilities
```

## 🎯 Usage

### Getting Started
1. Launch the app and you'll see the main navigation with 6 tabs:
   - **Learn**: Start your learning journey
   - **Levels**: Browse all available levels
   - **Nouns**: Explore German nouns
   - **Verbs**: Study German verbs
   - **Sentences**: Learn common phrases
   - **More**: Additional features (Exam, Practice, Categories)

### Learning a Lesson
1. Navigate to **Learn** or **Levels** tab
2. Select your proficiency level (A1, A2, B1, or B2)
3. Choose a module
4. Start learning topics within the module
5. Use TTS to hear pronunciations
6. Complete lessons to track progress

### Taking an Exam
1. Go to **More** tab
2. Select **Exam**
3. Choose your level (A1, A2, B1, or B2)
4. Answer questions within the time limit
5. Review your results and correct answers

### Practicing
1. Navigate to **More** tab
2. Select **Practice**
3. Practice without time constraints
4. Review answers and explanations

## 🎨 UI/UX Features

- **Modern Design**: Clean, intuitive interface
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Responsive Layout**: Adapts to different screen sizes
- **Accessibility**: Support for different text sizes and themes
- **Visual Feedback**: Clear indicators for progress and completion

## 🔧 Configuration

### Theme Customization
The app uses a centralized theme service. Customize themes in `lib/backend/services/theme_service.dart`.

### TTS Settings
Adjust TTS speed and language settings in `lib/backend/services/tts_service.dart`.

### Learning Data
Learning content is stored in JSON files in `Assets/learn_module/` and `lib/Data/json/`.

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web (partial support)
- ✅ Desktop (Linux, macOS, Windows)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Contribution Guidelines
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX for state management
- All contributors and users of this project

## 📞 Support

For support, please open an issue in the GitHub repository or contact the development team.

## 🗺️ Roadmap

- [ ] Complete C1 and C2 level content
- [ ] Add more interactive exercises
- [ ] Implement spaced repetition system
- [ ] Add user accounts and cloud sync
- [ ] Expand vocabulary database
- [ ] Add more language options
- [ ] Implement gamification features
- [ ] Add social features (leaderboards, sharing)

---

**Made with ❤️ for German language learners worldwide**
