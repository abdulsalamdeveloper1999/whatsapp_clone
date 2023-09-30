import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/utils/components/utils.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void pickImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    ref
        .read(authControllerProvider)
        .saveUserDataToFirebase(context, name, image);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(image!),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/man.png'),
                        ),
                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: IconButton(
                      onPressed: pickImage,
                      icon: Icon(
                        Icons.camera_alt,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.85,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: storeUserData,
                      child: Icon(Icons.done),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
