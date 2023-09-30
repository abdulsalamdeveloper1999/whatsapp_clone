import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';

import '../../../utils/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthController(authRepository: authRepository, ref: ref);

  ///ref.watch is basically Provider.of<ProviderName>(context)
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.ref,
    required this.authRepository,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(context, phoneNumber) {
    authRepository.signInWithPhone(
      context,
      phoneNumber,
    );
  }

  void verifyOtp(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOtp(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepository.saveUserDataToFirebase(
      profilePic: profilePic,
      name: name,
      ref: ref,
      context: context,
    );
  }

  Stream<UserModel> userDataById(String id) {
    return authRepository.userData(id);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
