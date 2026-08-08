import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<bool> userExists() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await _firestore
        .collection("users")
        .doc(uid)
        .get();

    return doc.exists;
  }

  Future<void> createUser({

    required String name,

    required String phone,

  }) async {

    final user = FirebaseAuth.instance.currentUser!;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .set({

      "uid": user.uid,

      "phone": phone,

      "name": name,

      "profileImage": "",

      "about": "Hey there! I'm using Chat App.",

      "online": true,

      "lastSeen": FieldValue.serverTimestamp(),

      "createdAt": FieldValue.serverTimestamp(),

    });

  }

}