import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/hive_service.dart';
import 'providers/language_provider.dart';
import 'providers/hive_status_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final hiveStatus = ref.watch(hiveStatusProvider);

    return MaterialApp(
      title: 'Mini E-commerce',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1), // Vibrant indigo
          secondary: Color(0xFFEC4899), // Vibrant pink
          tertiary: Color(0xFF10B981), // Vibrant emerald
          surface: Color(0xFFFEFEFE),
          background: Color(0xFFF8FAFC),
          error: Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFF1E293B),
          onBackground: Color(0xFF1E293B),
          outline: Color(0xFFE2E8F0),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardTheme(
          elevation: 8,
          shadowColor: const Color(0xFF6366F1).withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 8,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF6366F1),
          unselectedItemColor: Color(0xFF94A3B8),
          elevation: 16,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF818CF8), // Lighter indigo for dark mode
          secondary: Color(0xFFF472B6), // Lighter pink for dark mode
          tertiary: Color(0xFF34D399), // Lighter emerald for dark mode
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
          error: Color(0xFFF87171),
          onPrimary: Color(0xFF0F172A),
          onSecondary: Color(0xFF0F172A),
          onSurface: Color(0xFFF1F5F9),
          onBackground: Color(0xFFF1F5F9),
          outline: Color(0xFF475569),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardTheme(
          elevation: 8,
          shadowColor: const Color(0xFF818CF8).withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Color(0xFFF1F5F9),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      locale: locale,
      home: HomeScreen(),
    );
  }
}
