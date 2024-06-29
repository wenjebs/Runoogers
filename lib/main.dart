import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/global_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:runningapp/pages/login_and_registration/auth_page.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';

String geminiApiKey = const String.fromEnvironment('GEMINI_API_KEY');
String mapsApiKey = const String.fromEnvironment('MAPS_API_KEY');
String orsApiKey = const String.fromEnvironment('ORS_API_KEY');
void main() async {
  // ensure widgetbinding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Api Keys $geminiApiKey $mapsApiKey $orsApiKey");

  // load env variables
  await dotenv.load(fileName: "dotenv.env");

  // check if all required env variables are defined
  const requiredEnvVars = ["MAPS_API_KEY"];
  if (!dotenv.isEveryDefined(requiredEnvVars)) {
    throw ("no api!");
  }
  if (geminiApiKey == "" || mapsApiKey == "" || orsApiKey == "") {
    geminiApiKey = dotenv.env["GEMINI_API_KEY"]!;
    mapsApiKey = dotenv.env["MAPS_API_KEY"]!;
    orsApiKey = dotenv.env["ORS_API_KEY"]!;
  }

  debugPrint("Api Keys $geminiApiKey $mapsApiKey $orsApiKey");
  // initialize firebase auth
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialise gemini api
  Gemini.init(apiKey: geminiApiKey);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // print(dotenv.env["MAPS_API_KEY"]);
    }
    return MaterialApp(
      theme: GlobalThemeData.lightThemeData,
      darkTheme: GlobalThemeData.darkThemeData,
      themeMode: ThemeMode.system,
      title: 'Goorunners',
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
