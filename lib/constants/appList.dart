import 'package:bloodfit/routes/routes.dart';

import '../features/my_profile/model/profile_tile_model.dart';
import '../features/onboarding/model/onboarding_model.dart';
import '../gen/assets.gen.dart';

class AppList {
  static List<OnboardingModel> onboardingList = [
    OnboardingModel(
      title: "Tailored Mealplan To Blood Type",
      subTitle:
          "Choose From Personalized Meal Plans That Match Your Blood Type, Designed To Optimize Your Health And Fitness.",
      imagePath: Assets.images.onboardingImageOne.path,
    ),
    OnboardingModel(
      title: "Fuel Your Body, Then Move It",
      subTitle:
          "With  Your Personalized Meals Get Your Fitness To The Next Level. Align Your Workout Routine With The Same Precision As Your Nutrition.",
      imagePath: Assets.images.onboardingImageTwo.path,
    ),
    OnboardingModel(
      title: "Get Your 7-Day Free Trial",
      subTitle:
          "Experience All The Benefits Of Our Meal Plans With A 7-Day Free Trial! Get Access To Personalized Meal Suggestions, Track Your Progress, And Enjoy Healthy Meals Tailored To Your Needs.",
      imagePath: Assets.images.onboardingImageThree.path,
    ),
    OnboardingModel(
      title: "1-day streak",
      subTitle: "Awesome! Every Streak Counts, Keep It Going!",
      imagePath: Assets.images.onboardingImageFour.path,
    ),
  ];

  static List<ProfileTileModel> freeUserProfileTileList = [
    ProfileTileModel(
      imagePath: Assets.icons.personIcon,
      title: "Edit Profile",
      route: Routes.editProfileScreen,
    ),
    ProfileTileModel(
      imagePath: Assets.icons.settingsIcon,
      title: "Settings",
      route: Routes.settingsScreen,
    ),
  ];

  static List<ProfileTileModel> premimumUserProfileTileList = [
    ProfileTileModel(
      imagePath: Assets.icons.personIcon,
      title: "Edit Profile",
      route: Routes.editProfileScreen,
    ),
    ProfileTileModel(
      imagePath: Assets.icons.mealIcon,
      title: "Mealplan",
      route: Routes.mealPlanScreen,
    ),
    ProfileTileModel(
      imagePath: Assets.icons.fitnessIcon,
      title: "Fitness",
      route: Routes.fitnessScreen,
    ),
    ProfileTileModel(
      imagePath: Assets.icons.settingsIcon,
      title: "Settings",
      route: Routes.settingsScreen,
    ),
    ProfileTileModel(
      imagePath: Assets.icons.mealIcon,
      title: "Subscription: Starter",
      route: Routes.subscriptionScreen,
    ),
  ];

  // Blood group list
  static final bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];

  /// Gender List
  static final List<String> genderList = ["Male", "Female"];

  ///Height List
  // Height options for humans in cm (from 120cm to 210cm)
  static final List<String> humanHeightsList = [
    "120 cm",
    "125 cm",
    "130 cm",
    "135 cm",
    "140 cm",
    "145 cm",
    "150 cm",
    "155 cm",
    "160 cm",
    "165 cm",
    "170 cm",
    "175 cm",
    "180 cm",
    "185 cm",
    "190 cm",
    "195 cm",
    "200 cm",
    "205 cm",
    "210 cm",
  ];

  // Weight options for humans in kg (from 30kg to 150kg, step 5kg)
  static final List<String> humanWeightsList = [
    "30 kg",
    "35 kg",
    "40 kg",
    "45 kg",
    "50 kg",
    "55 kg",
    "60 kg",
    "65 kg",
    "70 kg",
    "75 kg",
    "80 kg",
    "85 kg",
    "90 kg",
    "95 kg",
    "100 kg",
    "105 kg",
    "110 kg",
    "115 kg",
    "120 kg",
    "125 kg",
    "130 kg",
    "135 kg",
    "140 kg",
    "145 kg",
    "150 kg",
  ];
}
