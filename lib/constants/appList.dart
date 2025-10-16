import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_diet/model/picke_your_diet_model.dart';
import 'package:bloodfit/features/my_profile/model/personal_data_model.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/profile_optoin_tile_extension.dart';
import 'package:bloodfit/features/settings/widgets/settings_option_title_extension.dart';
import 'package:bloodfit/routes/routes.dart';

import '../features/faq/model/faq_model.dart';
import '../features/information_gather/presentation/widgets/select_gender/gender_model.dart';
import '../features/my_profile/model/profile_tile_model.dart';
import '../features/onboarding/model/onboarding_model.dart';
import '../features/subscription/model/subscription_package_model.dart';
import '../gen/assets.gen.dart';
import '../utils/card_tile_option_model.dart';

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

  static List<CardTileOptionModel<ProfileOptionsTitle>>
  freeUserProfileTileList = [
    CardTileOptionModel(
      imagePath: Assets.icons.penIcon,
      titleEnum: ProfileOptionsTitle.editProfile,
      route: Routes.editProfileScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.settingsIcon,
      titleEnum: ProfileOptionsTitle.setTings,
      route: Routes.settingsScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.mealIcon,
      titleEnum: ProfileOptionsTitle.subscriptoinType,
      route: Routes.subscriptionScreen,
      labelMapper: (e) => e.label,
    ),
  ];

  static List<CardTileOptionModel<ProfileOptionsTitle>>
  premimumUserProfileTileList = [
    CardTileOptionModel(
      imagePath: Assets.icons.personIcon,
      titleEnum: ProfileOptionsTitle.editProfile,
      route: Routes.editProfileScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.mealIcon,
      titleEnum: ProfileOptionsTitle.mealPlan,
      route: Routes.mealPlanScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.fitnessIcon,
      titleEnum: ProfileOptionsTitle.fitNess,
      route: Routes.fitnessScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.settingsIcon,
      titleEnum: ProfileOptionsTitle.setTings,
      route: Routes.settingsScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.mealIcon,
      titleEnum: ProfileOptionsTitle.subscriptoinType,
      route: Routes.subscriptionScreen,
      labelMapper: (e) => e.label,
    ),
  ];

  // Blood group list
  static final bloodGroups = ["A", "B", "O", "AB"];

  ///"A", "B", "O", "AB"

  /// Gender List
  static final List<String> genderList = ["Male", "Female"];

  /// Personal Data List
  static final List<PersonalDataModel> personalDataList = [
    PersonalDataModel(data: "175 Cm", field: "Height"),
    PersonalDataModel(data: "85 Kg", field: "Weight"),
    PersonalDataModel(data: "Female", field: "Sex"),
    PersonalDataModel(data: "A Positive", field: "Blood Type"),
  ];

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

  static List<CardTileOptionModel<SettingsOptionTitle>> settingsScreenList = [
    CardTileOptionModel(
      imagePath: Assets.icons.lockIcon,
      titleEnum: SettingsOptionTitle.changePassword,
      sectionTitle: " Account Management",

      route: Routes.changePasswordScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.fileIcon,
      titleEnum: SettingsOptionTitle.termsAndConditions,
      sectionTitle: "Legal & Privacy",
      route: Routes.termsAndConditionsScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.privacyPolicyIcon,
      titleEnum: SettingsOptionTitle.privacyPolicy,
      route: Routes.privacyPolicyScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.warningIcon,
      titleEnum: SettingsOptionTitle.reportAProblem,
      sectionTitle: "Support",
      route: Routes.reportProbelmScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.faqIcon,
      titleEnum: SettingsOptionTitle.faq,
      route: Routes.faqScreen,
      labelMapper: (e) => e.label,
    ),
    CardTileOptionModel(
      imagePath: Assets.icons.deleteUserIcon,
      titleEnum: SettingsOptionTitle.deleteAccount,
      route: Routes.myProfileScreen,
      labelMapper: (e) => e.label,
    ),
  ];

  static List<String> reportProblemTypeList = [
    "Account Login Issue",
    "App Crashing or Freezing",
    "Data Not Syncing",
    "Incorrect Information Displayed",
    "Payment or Subscription Problem",
    "Feature Not Working",
    "Bug or Error Message",
    "Notification Not Showing",
    "Performance Issue (Slow, Lag, Delay)",
    "UI/UX Problem",
    "Request for New Feature",
    "Feedback or Suggestion",
    "Other",
  ];

  static List<FaqModel> faqList = [
    FaqModel(
      question: "How can I reset my password?",
      ans:
          "Go to the login page and tap on 'Forgot Password'. Enter your registered email address, and you'll receive a link to reset your password.",
    ),
    FaqModel(
      question: "How do I contact support?",
      ans:
          "You can contact our support team through the 'Report a Problem' section inside the app or email us directly at support@bloodfit.com.",
    ),
    FaqModel(
      question: "Can I update my profile information?",
      ans:
          "Yes, go to the Profile tab and tap 'Edit Profile' to update your personal details, including name, contact number, and location.",
    ),
    FaqModel(
      question: "Is my data secure?",
      ans:
          "Absolutely. All your information is encrypted and stored securely following industry best practices.",
    ),
    FaqModel(
      question: "Can I delete my account?",
      ans:
          "Yes, you can delete your account anytime from Settings → Account → Delete Account. Note that this action is irreversible.",
    ),
  ];

  static List<String> bodyShapesList = [
    "Ectomorph",
    "Mesomorph",
    "Endomorph",
    "Hourglass",
    "Pear",
    "Apple",
    "Rectangle",
    "Inverted Triangle",
    "Diamond",
    "Top Hourglass",
    "Bottom Hourglass",
  ];

  static List<String> dailyActivityLevelsList = [
    "Sedentary",
    "Lightly Active",
    "Moderately Active",
    "Very Active",
    "Extra Active",
  ];

  static List<String> workoutLevelsList = [
    "Sedentary",
    "Light",
    "Moderate",
    "Intense",
    "Very Intense",
    "Competitive",
  ];

  static const List<String> workoutGoalsList = [
    "Build Muscle",
    "Lose Fat",
    "Increase Strength",
    "Improve Endurance",
    "Enhance Flexibility",
    "Improve Overall Fitness",
    "Rehabilitation",
    "Weight Maintenance",
  ];

  static List<String> workoutFocusAreasList = [
    "Full Body",
    "Upper Body",
    "Lower Body",
    "Core / Abs",
    "Arms",
    "Legs",
    "Back",
    "Chest",
    "Shoulders",
    "Glutes",
    "Cardio / Endurance",
    "Flexibility / Stretching",
    "Balance / Stability",
  ];

  static List<String> dietTypesList = [
    "Balanced Diet",
    "High-Protein Diet",
    "Low-Carb Diet",
    "Keto Diet",
    "Vegan Diet",
    "Vegetarian Diet",
    "Paleo Diet",
    "Mediterranean Diet",
    "Intermittent Fasting",
    "Gluten-Free Diet",
    "DASH Diet",
    "Flexitarian Diet",
    "Low-Fat Diet",
  ];

  static List<String> daysOfWeekList = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  static List<String> mealAllergiesList = [
    'Gluten',
    'Dairy',
    'Eggs',
    'Peanuts',
    'Tree Nuts',
    'Soy',
    'Shellfish',
    'Fish',
    'Sesame',
    'Wheat',
    'Corn',
    'Mustard',
    'Celery',
    'Sulphites',
    'Lupin',
    'Caffeine',
    'Pork',
    'Beef',
    'Lamb',
    'Alcohol',
    'Sugar',
    'Artificial Sweeteners',
    'Processed Foods',
  ];

  static const List<String> dislikedFoodList = [
    'Gluten',
    'Dairy',
    'Eggs',
    'Peanuts',
    'Soy',
    'Seafood',
    'Wheat',
    'Tree Nuts',
    'Shellfish',
    'Red Meat',
    'Spicy Food',
    'Onions',
    'Garlic',
    'Tomatoes',
    'Mushrooms',
    'Bell Peppers',
    'Cucumber',
    'Lactose',
    'Chocolate',
    'Coffee',
    'Alcohol',
    'Citrus Fruits',
    'Bananas',
    'Strawberries',
    'Rice',
    'Pasta',
    'Bread',
    'Sugar',
    'Artificial Sweeteners',
  ];

  static final List<SubscriptionPackageModel> subscriptionPackagesList = [
    SubscriptionPackageModel(
      isDiscountOfferAvailable: true,
      packageType: "Free",
      packageDuration: "Monthly",
      packagePrice: 0.0,
      discountOffer: "Get 50% Discount On The First Month",
      packageOffersList: [
        "Access to basic features",
        "Limited meal plan customization",
        "Community support access",
      ],
      isActive: true,
    ),
    SubscriptionPackageModel(
      isDiscountOfferAvailable: true,
      packageType: "Starter",
      packageDuration: "Yearly",
      packagePrice: 19.99,
      isActive: false,
      discountOffer: "Get 50% Discount On The First Month",
      packageOffersList: [
        "All Free features",
        "Weekly meal recommendations",
        "Calorie tracking dashboard",
      ],
    ),
    SubscriptionPackageModel(
      isDiscountOfferAvailable: true,
      packageType: "Pro",
      packageDuration: "Monthly",
      packagePrice: 49.99,
      isActive: false,
      discountOffer: "Get 50% Discount On The First Month",
      packageOffersList: [
        "All Starter features",
        "Personalized AI meal planning",
        "Fitness tracking integration",
        "Exclusive pro community access",
      ],
    ),
    SubscriptionPackageModel(
      isDiscountOfferAvailable: true,
      packageType: "Elite",
      packageDuration: "Yearly",
      packagePrice: 89.99,
      isActive: false,
      discountOffer: "Get 50% Discount On The First Month",
      packageOffersList: [
        "All Pro features",
        "1-on-1 nutritionist support",
        "Priority updates & supportPriority updates & support",
        "Exclusive elite insights dashboard",
      ],
    ),
  ];

  static List<GenderModel> genderWithIconList = [
    GenderModel(iconPath: Assets.icons.maleIcon, title: "Male"),
    GenderModel(iconPath: Assets.icons.femaleIcon, title: "Female"),
  ];

  static final List<PickeYourDietModel> pickYourDietList = [
    PickeYourDietModel(dietName: "Classic", dietType: "No Hold Barred"),
    PickeYourDietModel(dietName: "Vegan", dietType: "Plant Based"),
    PickeYourDietModel(dietName: "Pescatarian", dietType: "Seafood-Based"),
    PickeYourDietModel(dietName: "Carnivore", dietType: "Meat-Focused"),
    PickeYourDietModel(dietName: "Vagiterian", dietType: "Meat-Focused"),
  ];
}
