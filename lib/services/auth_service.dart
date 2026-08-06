import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        verificationFailed(e.message ?? "Verification Failed");
      },

      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}