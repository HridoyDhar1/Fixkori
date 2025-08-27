
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serviceapp/core/widgets/subcription_screen.dart';
import 'package:serviceapp/feature/Admin/Auth/screens/create_admin.dart';
import 'package:serviceapp/feature/Admin/Auth/screens/info_screen.dart';
import 'package:serviceapp/feature/Admin/Home/presentaion/screen/home_screen.dart';

import 'package:serviceapp/feature/Admin/Profile/widget/edit_profile.dart';
import 'package:serviceapp/feature/Admin/order/screen/order_screen.dart';
import 'package:serviceapp/feature/Auth/presentation/screens/login_screen.dart';
import 'package:serviceapp/feature/Auth/presentation/screens/onboarding_screen_one.dart';
import 'package:serviceapp/feature/Auth/presentation/screens/singup_screen.dart';
import 'package:serviceapp/feature/Auth/presentation/screens/splash_screen.dart';
import 'package:serviceapp/feature/SuperAdmin/presentation/screen/dashboard_screen.dart';
import 'package:serviceapp/feature/User/Home/screen/user_home.dart';
import 'package:serviceapp/feature/User/Profile/presentation/screen/edit_profile.dart';
import 'package:serviceapp/feature/User/user_navigation.dart';
import 'package:serviceapp/navigation.dart';

import '../lang/translations.dart';
import 'controller_binding.dart';



class ServiceApp extends StatefulWidget {
  const ServiceApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<ServiceApp> createState() => _ServiceAppState();
}

class _ServiceAppState extends State<ServiceApp> {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('en'), // default
      fallbackLocale: const Locale('en'),



      navigatorKey: ServiceApp.navigatorKey,
      initialBinding: ControllerBinding(),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      getPages: [
GetPage(name: "/splash_screen", page: ()=>SplashScreen()),
        GetPage(name: "/onboarding_screen", page: ()=>OnboardingScreen()),
        GetPage(name: "/login", page: ()=>LoginScreen()),
        GetPage(name: "/edit_userprofile", page:()=> EditUserProfileScreen()),
        GetPage(name: "/signup", page: ()=>SignupScreen()),
        GetPage(name: "/home_admin", page:()=>HomeScreenAdmin()),
        GetPage(name: "/navigation", page: ()=>CustomNavigationScreen()),
        GetPage(name: "/admin_profile", page: ()=>CreateAdmin()),
        GetPage(name: "/worker_reg", page: ()=>AdminSplashScreen()),
GetPage(name: "/subscription", page:()=> SubscriptionScreen()),
        GetPage(
          name: "/order",
          page: () {
            final adminId = Get.arguments as String;
            return AdminOrdersScreen();
          },
        ),

GetPage(name: "/admin_dashboard", page: ()=>AdminDashboardScreen()),
        GetPage(name: "/user_home", page: ()=>UserHomeScreen()),
        GetPage(name: "/user_navigation", page: ()=>CustomUserNavigationScreen())
      ],
    );
  }
}
