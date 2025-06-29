import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutapp2/screens/main_nav_screen.dart';
import 'screens/workout_screen.dart';
import 'data/objectbox_helper.dart';
import 'providers/workout_provider.dart';
import 'theme/app_styles.dart';


late final ObjectBoxHelper objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBoxHelper.create();
  runApp(
    ProviderScope(
      overrides: [
        objectBoxProvider.overrideWithValue(objectBox),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: AppStyles.defaultRadius),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: CardThemeData(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.defaultRadius,
          ),
        ),

      ),

      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system, // supports light/dark toggle later
      home: const MainNavScreen(),
    );

  }
}
