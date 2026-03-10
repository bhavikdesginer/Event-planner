// this file stores temporary data across onboarding screens

// Holds onboarding data temporarily between screens
class OnboardingData {
  static String name = '';
  static String email = '';
  static String password = '';
  static String phone = '';
  static String verificationId = '';
  static String gender = '';
  static int age = 18;
  static List<String> interests = [];
  static String location = '';

  static void clear() {
    name = '';
    email = '';
    password = '';
    phone = '';
    verificationId = '';
    gender = '';
    age = 18;
    interests = [];
    location = '';
  }
}