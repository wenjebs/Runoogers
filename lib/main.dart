import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/global_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:runningapp/pages/login_and_registration/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "dotenv.env");
  const requiredEnvVars = ["MAPS_API_KEY"];
  if (!dotenv.isEveryDefined(requiredEnvVars)) {
    throw ("no api!");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(dotenv.env["MAPS_API_KEY"]);
    }
    return MaterialApp(
      theme: GlobalThemeData.lightThemeData,
      darkTheme: GlobalThemeData.darkThemeData,
      themeMode: ThemeMode.system,
      title: 'Runoogers',
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
