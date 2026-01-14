// ignore_for_file: constant_identifier_names

// const String url = "https://sebaev.softvencefsd.xyz";

const String url = "https://faisal5000.merinasib.shop/api/v1";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "en";
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();
  //backend_url

  ///Signout Api Not Used
  static String signOut() => "$url/api/auth/logout";

  ///---->>Api Link Starts From Here
  static String signUp() => "$url/auth/register";
  static String signIn() => "$url/auth/login";
  static String verifyOtp() => "$url/auth/verify-otp";
  static String resendOtp() => "$url/auth/resend-otp";
  static String forgotPassword() => "$url/auth/forget-password";
  static String resetPassword() => "$url/auth/reset-password";
  static String changePassword() => "$url/auth/change-password";
  static String termsAndConditions() => "$url/terms/";
  static String privacyPolicy() => "$url/privacy/";
  static String reportAProblem() => "$url/report/create-report";
  static String deleteAccount({required String userId}) {
    return "$url/auth/account-delete?id=$userId";
  }
}



// static String personalQuote() => "/api/personal-quote";
  // static String remainder(String slug) => "/api/reminder/$slug";
  // static String deleteRemainder(int slug) => "/api/reminder/$slug";
  // static String quoteListByCategoryWithIdes(ids) =>
  //     "/api/quote?per_page=1000&page=1&categories=$ids";