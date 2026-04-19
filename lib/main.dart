import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/authentication/presentation/pages/auth_gate.dart';
import 'package:events_app/authentication/presentation/pages/google_register_screen.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/api_template/event_network.dart';
import 'package:events_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  configureDependencies(env: appEnv);
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://events-backend-tgrs.onrender.com/api',
  );
  EventNetwork.setBaseUrl(baseUrl: apiBaseUrl);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError catch (e) {
    debugPrint('Firebase not configured for this platform: $e');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Events App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      getPages: [
        GetPage(
          name: '/register/google',
          page: () {
            final args = Get.arguments as Map<String, dynamic>?;
            final isStudent = args?['isStudent'] as bool? ?? true;
            return GoogleRegisterScreen(isStudent: isStudent);
          },
        ),
      ],
    );
  }
}
