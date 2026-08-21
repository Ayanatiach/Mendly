import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'stitch_ui/login_dark_mode/login_screen.dart';

void main() {
  // Ensure Flutter engine bindings are initialized first
  WidgetsFlutterBinding.ensureInitialized();

  // Graceful fallback for UI rendering exceptions to prevent blank screen crashes on mobile
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFF2E0014),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFD90429), size: 48),
              const SizedBox(height: 16),
              const Text(
                'Something unexpected occurred',
                style: TextStyle(
                  color: Color(0xFFF2F0E6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                details.exceptionAsString(),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFE7BCBA),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const MendlyApp());
}

/// Root Application Widget configuring themes and state providers
class MendlyApp extends StatelessWidget {
  const MendlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Injects global application state across the widget tree
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Mendly',
            debugShowCheckedModeBanner: false,
            themeMode: appState.currentTheme,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFFBF9F2), // Alabaster Grey
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFD90429), // Racing Red
                secondary: Color(0xFF10B981),
                surface: Colors.white,
                onSurface: Color(0xFF1A0D08), // Coffee Beans
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF2F0E6),
                foregroundColor: Color(0xFF1A0D08),
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF2E0014), // Black Cherry
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFD90429), // Racing Red
                secondary: Color(0xFF10B981),
                surface: Color(0xFF1A0D08), // Coffee Beans
                onSurface: Color(0xFFF2F0E6), // Alabaster Grey
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1A0D08),
                foregroundColor: Color(0xFFF2F0E6),
                elevation: 0,
              ),
            ),
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
