import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'providers/auth_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Try to initialize Firebase
  // We use try-catch to allow the app to run even if configuration is missing (for demo purposes)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Continue running app without Firebase if it fails (using mock data in this case? 
    // Data layer needs to handle this)
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const GarasifyyApp(),
    ),
  );
}

class GarasifyyApp extends StatelessWidget {
  const GarasifyyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access auth provider to pass to router for redirection logic
    final authProvider = Provider.of<AuthProvider>(context);
    
    return MaterialApp.router(
      title: 'Garasifyy',
      debugShowCheckedModeBanner: false,
      theme: GarasifyyTheme.darkTheme,
      routerConfig: AppRouter.getRouter(authProvider),
    );
  }
}
