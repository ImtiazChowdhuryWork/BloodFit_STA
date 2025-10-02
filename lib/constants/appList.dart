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
    ProfileTileModel(imagePath: Assets.icons.personIcon, title: "Edit Profile"),
    ProfileTileModel(imagePath: Assets.icons.settingsIcon, title: "Settings"),
  ];

  static List<ProfileTileModel> premimumUserProfileTileList = [
    ProfileTileModel(imagePath: Assets.icons.personIcon, title: "Edit Profile"),
    ProfileTileModel(imagePath: Assets.icons.mealIcon, title: "Mealplan"),
    ProfileTileModel(imagePath: Assets.icons.fitnessIcon, title: "Fitness"),
    ProfileTileModel(imagePath: Assets.icons.settingsIcon, title: "Settings"),
    ProfileTileModel(
      imagePath: Assets.icons.mealIcon,
      title: "Subscription: Starter",
    ),
  ];
}
