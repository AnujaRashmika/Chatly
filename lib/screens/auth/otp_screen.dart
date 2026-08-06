import 'package:flutter/material.dart';

class OTPPage extends StatelessWidget {

  final String verificationId;
  final String phoneNumber;

  const OTPPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),

      body: Center(

        child: Text(
          "OTP sent to\n$phoneNumber",
          textAlign: TextAlign.center,
        ),

      ),

    );

  }

}