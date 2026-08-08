import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Decide the starting screen *before* runApp so there's no splash
  // screen / flicker in between — the right screen just opens directly:
  // onboarding not done  -> Onboarding
  // onboarding done, no user logged in -> Login
  // onboarding done, user already logged in -> Home
  final bool onboardingCompleted = await Preferences.isOnboardingCompleted();
  final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

  // App Check activate
  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
  );

  runApp(ChatApp(
    onboardingCompleted: onboardingCompleted,
    isLoggedIn: isLoggedIn,
  ));
}

class ChatApp extends StatelessWidget {
  final bool onboardingCompleted;
  final bool isLoggedIn;

  const ChatApp({
    super.key,
    required this.onboardingCompleted,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    // Pick the very first screen the user sees — no splash screen widget.
    Widget startScreen;
    if (!onboardingCompleted) {
      startScreen = const OnboardingScreen();
    } else if (!isLoggedIn) {
      startScreen = const LoginScreen();
    } else {
      startScreen = const HomeScreen();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chat App",
        home: startScreen,
      ),
    );
  }
}