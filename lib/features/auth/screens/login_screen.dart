import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/utils/components/mybutton.dart';
import 'package:whatsapp_ui/utils/components/mytext.dart';
import 'package:whatsapp_ui/utils/components/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(
            context,
            '+${country!.phoneCode}${phoneNumber}',
          );

      ///.read() -> Provider.of(context,listen:false)
      /// Provider ref -> Interact with provider
      ///Widget ref -> makes widget interact with provider
    } else {
      showSnackBar(context: context, content: 'Fill out all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              MyText(
                text: 'WhatsApp will need to verify your phone number',
                size: 16.0,
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: pickCountry,
                child: Text('Pick Country'),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  if (country != null)
                    MyText(
                      text: '+${country!.phoneCode}',
                      size: 16.0,
                    ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 90,
                child: MyButton(
                  onTap: sendPhoneNumber,
                  text: 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
