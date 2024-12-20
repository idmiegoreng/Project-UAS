import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'models/weekly_balance.dart';

class AppState extends ChangeNotifier {
  List<WeeklyBalance> weeklyBalances = [];
  WeeklyBalance? currentWeek;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void startNewWeek(double initialBalance) {
    final newWeek = WeeklyBalance(
      weekNumber: (weeklyBalances.length + 1),
      initialBalance: initialBalance,
      startDate: DateTime.now(),
    );

    weeklyBalances.add(newWeek);
    currentWeek = newWeek;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void initializeData() {
    if (weeklyBalances.isEmpty) {
      startNewWeek(500000); 
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState()..initializeData(),
      child: const DompetKostApp(),
    ),
  );
}

class DompetKostApp extends StatelessWidget {
  const DompetKostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'DompetKost',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.themeMode,
          home: const HomeScreen(),
          builder: (context, child) {
            return MediaQuery(
              // Prevent text scaling that might break the UI
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        );
      },
    );
  }
}