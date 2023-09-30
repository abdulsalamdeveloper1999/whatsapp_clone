import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/utils/components/mybutton.dart';
import 'package:whatsapp_ui/utils/components/mytext.dart';

import '../../../colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            MyText(
              text: 'Welcome to Whatsapp',
              size: 33.0,
              weight: FontWeight.w600,
            ),
            SizedBox(height: size.height * 0.035),
            Image.asset(
              'assets/bg.png',
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(height: size.height / 9),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: MyText(
                align: TextAlign.center,
                text:
                    'Read our Privacy Policy. Tap "Agree and continue" to  accept the Terms of Service',
                size: 16.0,
                weight: FontWeight.w400,
                color: greyColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: MyButton(
                onTap: () => navigateToLoginScreen(context),
                text: 'Agree and Continue',
              ),
            )
          ],
        ),
      ),
    );
  }
}
