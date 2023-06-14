import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mbl_am/scripts/router.dart';
import 'package:mbl_am/widgets/theme.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid ? const FirebaseOptions(
      apiKey: "AIzaSyCmbeWIeIxbm61Y0GqM-ob5Pegn1kwikgs",
      appId: "1:480901643151:web:46f4c09f5f989ece1d69fa",
      messagingSenderId: "480901643151",
      projectId: "mbl-as",
      authDomain: "mbl-as.firebaseapp.com",
      measurementId: "G-PZ5V0B8JMG",
      storageBucket: "mbl-as.appspot.com",
    ) : null,
  );
  runApp(
    const RobotDetector(
      debug: false,
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      supportedLocales: const [
        Locale("pt", "BR"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Pitoco News',
      theme: theme,
      routerConfig: router,
    );
  }
}
