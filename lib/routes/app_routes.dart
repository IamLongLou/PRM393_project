import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/customer/customer_list_screen.dart';
import '../screens/sync/sync_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/stats/statistics_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String customerList = '/customer-list';
  static const String sync = '/sync';
  static const String history = '/history';
  static const String statistics = '/statistics';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    customerList: (context) => const CustomerListScreen(),
    sync: (context) => const SyncScreen(),
    history: (context) => const HistoryScreen(),
    statistics: (context) => const StatisticsScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
