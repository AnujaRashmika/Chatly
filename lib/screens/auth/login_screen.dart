import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String phoneNumber = "";

  static const String _lottieUrl =
      "https://lottie.host/e07d0892-9978-421e-92aa-f50d2e0177ef/Wl6q7FESA7.json";

  void _onContinuePressed() {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter mobile number"),
        ),
      );
      return;
    }

    print(phoneNumber);

    // NEXT STEP
    // Send OTP
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 900;

            if (isWide) {
              return _buildWebLayout();
            }

            return _buildMobileLayout();
          },
        ),
      ),
    );
  }

  // ---------------- MOBILE LAYOUT (unchanged) ----------------
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),

            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.network(
                _lottieUrl,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                frameRate: FrameRate.max,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Enter your mobile number to continue",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            IntlPhoneField(
              initialCountryCode: "LK",
              decoration: InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (phone) {
                phoneNumber = phone.completeNumber;
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _onContinuePressed,
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "You will receive an SMS verification code.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WEB / WIDE LAYOUT (split screen) ----------------
  Widget _buildWebLayout() {
    return Row(
      children: [
        // ---------- LEFT SIDE : big lottie animation ----------
        Expanded(
          child: Container(
            color: const Color(0xFFF5F9F6),
            alignment: Alignment.center,
            child: SizedBox(
              width: 360,
              height: 360,
              child: Lottie.network(
                _lottieUrl,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                frameRate: FrameRate.max,
              ),
            ),
          ),
        ),

        // ---------- RIGHT SIDE : form content ----------
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: ConstrainedBox(
                // caps the form width so the button doesn't stretch
                // across the whole right half of the screen
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Welcome",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Enter your mobile number to continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 40),

                      IntlPhoneField(
                        initialCountryCode: "LK",
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (phone) {
                          phoneNumber = phone.completeNumber;
                        },
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _onContinuePressed,
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "You will receive an SMS verification code.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}