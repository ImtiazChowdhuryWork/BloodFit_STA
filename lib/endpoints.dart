// ignore_for_file: constant_identifier_names

// const String url = "https://sebaev.softvencefsd.xyz";

const String url = "https://blood-api.billal.space";

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

  static String refreshToken() => "/api/auth/refresh-token";
  static String signUp() => "/api/auth/signup";
  static String signIn() => "/api/auth/login";
  static String signOut() => "/api/auth/logout";
  static String forgotPassword() => "/api/auth/forgot-password";
  static String verifyUserOtp(String otp) => "/api/auth/verify/otp/$otp";
  static String resetPasswordOtp() => "/api/auth/reset-password-otp";
  static String resetPassword() => '/api/auth/reset-password';
}



// static String personalQuote() => "/api/personal-quote";
  // static String remainder(String slug) => "/api/reminder/$slug";
  // static String deleteRemainder(int slug) => "/api/reminder/$slug";
  // static String quoteListByCategoryWithIdes(ids) =>
  //     "/api/quote?per_page=1000&page=1&categories=$ids";