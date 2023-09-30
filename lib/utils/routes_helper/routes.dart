import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_ui/features/select_contacts/screens/select_contacts_screen.dart';
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
          verificationId: verificationId,
        );
      });
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (BuildContext context) {
        return UserInformationScreen();
      });
    case SelectContactScreen.routeName:
      return MaterialPageRoute(builder: (BuildContext context) {
        return SelectContactScreen();
      });
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(builder: (BuildContext context) {
        return MobileChatScreen(name: name, uid: uid);
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
