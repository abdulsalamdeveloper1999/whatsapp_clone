import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';
import 'package:whatsapp_ui/utils/components/error_screen.dart';
import 'package:whatsapp_ui/utils/components/loader.dart';
import 'package:whatsapp_ui/utils/routes_helper/routes.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      onGenerateRoute: (settings) => generateRoute(settings),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          // color: appBarColor,
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return LandingScreen();
              }
              return MobileLayoutScreen();
            },
            error: (err, trace) {
              log('${err}');
              return ErrorScreen(error: err.toString());
            },
            loading: () => Loader(),
          ),
    );
  }
}
