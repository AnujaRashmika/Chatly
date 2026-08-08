import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber, // must be E.164 → +947XXXXXXXX
        timeout: const Duration(seconds: 60),

        // Android auto-retrieval (optional but recommended)
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
          } catch (e) {
            // Auto sign-in failed, user will enter OTP manually
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          print("======= Firebase Phone Auth Error =======");
          print("Code    : ${e.code}");
          print("Message : ${e.message}");
          print("=========================================");

          String message = e.message ?? "Verification Failed";

          // User-friendly messages
          switch (e.code) {
            case 'invalid-phone-number':
              message = "Invalid phone number format";
              break;
            case 'too-many-requests':
              message = "Too many requests. Please try again later";
              break;
            case 'quota-exceeded':
              message = "SMS quota exceeded. Check Firebase billing";
              break;
            case 'missing-client-identifier':
              message = "App not configured properly (check SHA-1 / google-services.json)";
              break;
            case 'app-not-authorized':
              message = "App not authorized. Check package name & SHA fingerprints";
              break;
          }

          verificationFailed(message);
        },

        codeSent: (String verificationId, int? resendToken) {
          print("OTP sent successfully. verificationId: $verificationId");
          codeSent(verificationId);
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout reached (optional)
        },
      );
    } catch (e) {
      verificationFailed(e.toString());
    }
  }

  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
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