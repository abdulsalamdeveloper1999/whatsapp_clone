import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/utils/components/mytext.dart';

import '../controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  static const routeName = '/otp-screen';
  final String verificationId;
  const OtpScreen({
    super.key,
    required this.verificationId,
  });

  void verifyOtp(WidgetRef ref, context, otp) {
    ref.read(authControllerProvider).verifyOtp(
          context,
          verificationId,
          otp,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: MyText(
            text: 'Verifying your Number',
            size: 16.0,
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              MyText(text: 'We have send an SMS with a code'),
              SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  onChanged: (value) {
                    if (value.length == 6) {
                      verifyOtp(ref, context, value.trim());
                      print('otp verify');
                    } else {
                      print('otp not verify');
                      // showSnackBar(
                      //     context: context, content: 'Otp Not Correct');
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
