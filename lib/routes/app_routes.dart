import 'package:flutter/material.dart';
import '../presentation/home_page/home_page.dart';
import '../presentation/login_register_page/login_page.dart';
import '../presentation/login_register_page/start_page.dart';
import '../presentation/profile_page/profile_page.dart';
import '../presentation/sleep_page/sleep_page.dart';
import '../presentation/trainingCalendar_page/trainingCalendar_page.dart';
import '../presentation/trainingCalendar_page/trainings_page.dart';
import '../presentation/trainingCalendar_page/treningsListPage.dart';
import '../presentation/workout_page/choose_plan_page.dart';



class AppRoutes {
  static const String loginPage = '/login_page';
  static const String startPage = '/start_page';
  static const String restartPasswordPage = '/restart_password_page';
  static const String registerpagePage = '/register_page';
  static const String homePage = '/home_page';
  static const String sleepPage = '/sleep_page';
  static const String trainingcalendarPage = '/trainingCalendar_page';
  static const String trainingsListPage = '/trainingsList_page';
  static const String trainingsPage = '/trainings_page';
  static const String choosePlanPage = '/chooseTrainingSet_page';
  static const String trainingSetPage = '/trainingSet_page';
  static const String profilepagePage = '/profile_page';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    loginPage: (context) => const LoginPage(),
    startPage: (context) => const StartPage(),
    homePage: (context) => const HomePage(),
    sleepPage: (context) => const SleepPage(),
    trainingcalendarPage: (context) => const TrainingCalendarPage(),
    trainingsListPage: (context) => const TrainingsListPage(),
    trainingsPage: (context) => const TrainingsPage(),
    choosePlanPage: (context) => const ChoosePlanPage(),
    profilepagePage: (context) => const ProfilePage(),
    initialRoute: (context) => const LoginPage(),
  };
}


