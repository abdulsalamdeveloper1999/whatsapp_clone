import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/utils/components/mybutton.dart';
import 'package:whatsapp_ui/utils/components/mytext.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
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
                  onTap: () {},
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
