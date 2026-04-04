# BloodFit - Blood Type-Based Fitness & Nutrition App

A comprehensive Flutter-based fitness and nutrition application that personalizes meal plans, workouts, and health tracking based on your blood type.

## 📱 Overview

BloodFit is a cross-platform mobile application (iOS, Android, Web, Windows) that leverages your blood type to provide customized fitness and nutrition recommendations. The app uses Firebase for authentication and backend services, combined with a modern Flutter frontend built using GetX state management.

## 💡 Core Idea & Philosophy

### The Blood Type Diet Theory

BloodFit is built on the premise that your blood type plays a significant role in how your body responds to different foods and exercise routines. The **Blood Type Diet**, popularized by Dr. Peter D'Adamo, suggests that each blood type (A, B, AB, and O) has unique nutritional needs and metabolic characteristics.

### How It Works

**1. Blood Type-Based Personalization**
- Each blood type is believed to have specific dietary strengths and sensitivities
- Type O: Often associated with high stomach acid and efficient metabolism, suited for high-protein diets
- Type A: May benefit from plant-based diets and calming exercises like yoga
- Type B: Typically more balanced digestion, can handle diverse foods
- Type AB: A mix of A and B characteristics, requiring a balanced approach

**2. Tailored Nutrition Plans**
The app creates meal plans that align with your blood type's supposed optimal foods:
- Recommends foods that are "beneficial" for your blood type
- Identifies foods to "avoid" based on potential sensitivities
- Suggests "neutral" foods that are generally safe
- Considers personal preferences like allergies, dislikes, and dietary restrictions

**3. Customized Workout Regimens**
Different blood types are thought to respond better to certain types of exercise:
- Type O: High-intensity workouts, weight training, running
- Type A: Calming activities like yoga, tai chi, light cardio
- Type B: Moderate exercises with balance, such as cycling, hiking
- Type AB: Combination of both intense and calming exercises

**4. Holistic Health Tracking**
BloodFit doesn't just stop at diet and exercise—it tracks:
- **Weight progression** over time with visual charts
- **Calorie intake** to ensure you're meeting your goals
- **Workout consistency** to build and maintain healthy habits
- **Meal adherence** to help you stay on track with your blood type plan

### Why This Approach?

The core philosophy is that **one-size-fits-all fitness doesn't work**. By personalizing recommendations based on blood type, BloodFit aims to:

- **Reduce inflammation** and digestive issues by avoiding problematic foods
- **Optimize metabolism** by eating foods your body processes efficiently
- **Improve energy levels** through better nutrition and appropriate exercise
- **Achieve sustainable results** with plans tailored to your body's unique needs
- **Build long-term habits** rather than short-term diet fixes

### The Science Behind It

While the blood type diet theory remains controversial in the scientific community, many users report positive results. BloodFit provides:
- A structured approach to healthy eating
- Accountability through tracking and streaks
- Community support and motivation
- Evidence-based calorie tracking alongside blood type recommendations

The app empowers users to experiment with blood type-based nutrition while tracking their own results to determine what works best for their individual body.

## ✨ Features

### 🔐 Authentication
- **Email/Password Sign Up & Sign In**
- **Google Sign-In** integration
- **OTP Verification** for secure authentication
- **Forgot Password** with email verification
- **Reset Password** functionality

### 🏠 Home Dashboard
- Daily calorie intake tracking
- Meal plan overview and management
- Weight update widgets
- Consistency streak tracking
- Calendar-based meal selection
- AI-powered meal suggestions

### 🍽️ Meal Planning
- **Personalized Meal Plans** based on blood type
- **Meal Scanner** - Camera-based meal recognition
- **Meal Details** with nutritional information
- **Meal Swap** functionality
- **Food Allergies & Dislikes** tracking
- **Suggested Meals** from AI recommendations
- **Calendar-based** meal scheduling
- **Review & Confirm** chosen meals

### 💪 Workout Plans
- **Customized Workouts** based on blood type and fitness level
- **Weekly Workout Calendar**
- **Workout Focus Areas** selection
- **Main Goal** setting (weight loss, muscle gain, etc.)
- **Extra Workouts** customization
- **Workout Completion** tracking
- **Video Demonstrations** for exercises
- **Activity Level** assessment

### 📊 Progress Tracking
- **Weight History** with visual charts
- **Progress Reports** with graphs
- **Goal Tracking** and milestones
- **Weight Progress** visualization using FL Chart
- **Consistency Stakes** monitoring

### 👤 Profile & Settings
- **User Profile** management
- **Edit Profile** with photo upload
- **Country Selection** for localization
- **Subscription Management**
- **Promo Code** redemption
- **Settings** customization
- **FAQ** section
- **Privacy Policy** & **Terms & Conditions**
- **Report a Problem** feature

### 🎯 Onboarding Flow
- Welcome screen with animated blood drop
- Blood type selection
- Gender selection
- Age picker
- Height selection with ruler picker
- Weight selection
- Activity level assessment
- Desired weight goal
- Workout focus area selection
- Food preferences (allergies, dislikes)
- Diet plan selection

### 🧠 AI-Powered Meal Selection (Core Feature)

**The heart of BloodFit** - A sophisticated meal recommendation system that combines AI generation with user preferences:

#### **How It Works:**
1. **AI Meal Generation** - Backend AI analyzes user profile (blood type, goals, preferences) and generates personalized meal suggestions
2. **Dual Fetching Mechanism** - Uses **Socket.IO** for real-time updates with **HTTP polling fallback** (3s intervals, 3min timeout) for reliability
3. **Three Meal Categories** - Each meal type (Breakfast, Lunch, Dinner) offers three options:
   - **Protein-Packed** - High-protein meals for muscle building
   - **Light & Fresh** - Lighter options for easy digestion
   - **Hearty & Comforting** - Balanced comfort meals

#### **Key Capabilities:**
- **One Meal Per Tab** - Users select exactly one breakfast, one lunch, and one dinner
- **Toggle Selection** - Tap to select/deselect meals with real-time visual feedback
- **Previously Selected Meals** - Shows user's historical choices for quick re-selection
- **Smart Caching** - JobId cached per day, meals cached per tab to minimize API calls
- **Progress Tracker** - Visual bottom bar showing selection progress (0/3 → 3/3)
- **Error Recovery** - Automatic retry, timeout handling, and user-friendly failure states
- **Meal Details** - Tap any meal to view full nutritional breakdown, ingredients, and macros
- **Build Meal Plan** - Once all 3 meals selected, users can review and confirm their daily plan

#### **Technical Highlights:**
- Reactive UI with **GetX Obx** for instant updates
- **Shimmer loading states** while AI generates meals
- **Base64 image support** for meal photos
- **Job ID system** - Async job tracking with socket listeners
- **Failure states** - Graceful error handling with retry buttons

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** - UI framework
- **Dart** - Programming language
- **SDK**: ^3.9.0

### State Management & Architecture
- **GetX** - State management, routing, and dependency injection
- **GetIt** - Service locator
- **Repository Pattern** - Clean architecture

### Backend & Services
- **Firebase Core** - Backend infrastructure
- **Firebase Auth** - Authentication
- **Google Sign-In** - Social authentication
- **Socket.IO** - Real-time communication
- **Dio** - HTTP client for API calls

### UI & UX
- **Flutter ScreenUtil** - Responsive design
- **Lottie** - Animations
- **FL Chart** - Data visualization
- **Shimmer** - Loading effects
- **Cached Network Image** - Image caching
- **Flutter SVG** - SVG support
- **Video Player** - Workout videos
- **Camera** - Meal scanning
- **Image Picker** - Profile photos
- **Custom Widgets** - Reusable UI components

### Utilities
- **Get Storage** - Local storage
- **Intl** - Internationalization and date formatting
- **Logger** - Debug logging
- **Device Info Plus** - Device information
- **Country Picker** - Country selection
- **Pinput** - OTP input
- **Dropdown Button2** - Enhanced dropdowns
- **Simple Circular Progress Bar** - Progress indicators
- **Dotted Border** - UI decorations
- **Path Provider** - File paths
- **HTTP** - Network requests

### Development Tools
- **Flutter Gen** - Asset code generation
- **Build Runner** - Code generation
- **Mockito** - Testing mocks
- **Flutter Lints** - Code quality

## 📁 Project Structure

```
lib/
├── bindings/              # GetX dependency bindings
├── constants/             # App constants, enums, validators
├── controllers/           # Global controllers
├── custom_widgets/        # Reusable UI components
├── extensions/            # Dart extensions
├── features/              # Feature modules (feature-first architecture)
│   ├── auth/             # Authentication features
│   ├── home/             # Home screen
│   ├── meal_plan_feature_options/
│   ├── meal_scanner/
│   ├── work_out/
│   ├── progress/
│   ├── subscription/
│   └── ...
├── gen/                   # Generated assets (Flutter Gen)
├── helper/                # Utility functions and DI setup
├── localization/          # Multi-language support
├── networks/              # Network layer
├── repositories/          # Data repositories
├── routes/                # App routing
├── utils/                 # Utility functions
├── main.dart              # App entry point
├── navigation_screen.dart # Main navigation
└── loading_screen.dart    # Loading screen
```

## 🌍 Localization

The app supports multiple languages:
- **English** (default)
- **Korean** (South Korean)

Language preferences are persisted across app restarts using Get Storage.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.9.0)
- Dart SDK
- Firebase CLI
- Android Studio / Xcode
- FVM (Flutter Version Management)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd blood_fit
   ```

2. **Install Flutter version**
   ```bash
   fvm install
   fvm use
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate asset classes**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Configure Firebase**
   - Ensure Firebase is set up for your project
   - Firebase options are already configured in `lib/firebase_options.dart`

6. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

BloodFit follows a **feature-first architecture** with clean separation of concerns:

```
Feature Module/
├── binding/          # Feature-specific bindings
├── data/
│   ├── controller/   # GetX controllers
│   ├── model/        # Data models
│   └── repository/   # Data repositories
└── presentation/
    └── widgets/      # Feature-specific widgets
```

### Key Architectural Patterns
- **MVVM with GetX** - Model-View-ViewModel pattern
- **Dependency Injection** - GetIt for service location
- **Repository Pattern** - Data abstraction layer
- **Reactive Programming** - Obx and GetBuilder for reactive UI updates

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows

## 🎨 Design System

- **Fonts**: Poppins, Montserrat
- **Responsive Design**: ScreenUtil-based adaptive sizing
- **Design Size**: 440x956 (base dimensions)
- **Colors**: Custom color palette defined in `assets/colors/colors.xml`
- **Icons**: SVG-based custom icons
- **Animations**: Lottie animations for enhanced UX

## 🔧 Configuration

### Firebase Setup
The app uses Firebase for:
- Authentication
- Cloud storage
- Real-time database
- Analytics

Firebase configuration is managed through `firebase.json` and `.firebaserc`.

### Asset Generation
Assets are auto-generated using Flutter Gen:
```bash
dart run build_runner watch
```

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📄 License

This project is private and not published to pub.dev.

## 👥 Contributing

This is a private project. For contributions, please:
1. Create a feature branch
2. Make your changes
3. Submit a pull request

## 📞 Support

For issues or questions:
- Check the FAQ section in the app
- Use the "Report a Problem" feature
- Review privacy policy and terms & conditions

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX for state management
- Firebase for backend services
- All open-source package contributors
