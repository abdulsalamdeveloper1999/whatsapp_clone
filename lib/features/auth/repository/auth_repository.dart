import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/repository/common_firebase_repository.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';
import 'package:whatsapp_ui/utils/components/utils.dart';
import 'package:whatsapp_ui/utils/models/user_model.dart';

///Use of Riverpod Here
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.firestore,
    required this.auth,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore
        .collection('usersCollection')
        .doc(auth.currentUser?.uid)
        .get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OtpScreen.routeName,
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOtp(
      {required context, required verificationId, required userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    File? profilePic,
    required String name,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = '';
      if (profilePic != null) {
        photoUrl =
            await ref.read(commonFirebaseRepositoryProvider).storeFileToStorage(
                  ref: 'profilePic/$uid',
                  file: profilePic,
                );
        var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: [],
        );

        await firestore
            .collection('usersCollection')
            .doc(uid)
            .set(user.toMap());
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const MobileLayoutScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String id) {
    return firestore.collection('usersCollection').doc(id).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('usersCollection')
        .doc(auth.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }
}
