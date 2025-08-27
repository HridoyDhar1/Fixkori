import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'signup': 'Sign Up',
      'dont_have_account': "Don't have an account?",
      'admin': "Admin?",
    },
    'bn': {
      'login': 'লগইন',
      'email': 'ইমেইল',
      'password': 'পাসওয়ার্ড',
      'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'signup': 'সাইন আপ',
      'dont_have_account': "একাউন্ট নেই?",
      'admin': "অ্যাডমিন?",
    },
  };
}
