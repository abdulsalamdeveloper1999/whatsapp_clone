import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/utils/components/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LoginScreen();
      });
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(builder: (BuildContext context) {
        return OtpScreen(
          verificatiomId: verificationId,
        );
      });

    default:
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: ErrorScreen(error: 'This page does\'nt exist'),
          );
        },
      );
  }
}
