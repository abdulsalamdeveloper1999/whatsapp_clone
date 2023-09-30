import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseRepositoryProvider = Provider(
  (ref) => CommonFirebaseRepository(
    firebaseStorage: FirebaseStorage.instance,
  ),
);

class CommonFirebaseRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseRepository({
    required this.firebaseStorage,
  });

  Future<String> storeFileToStorage({
    required String ref,
    required File file,
  }) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
