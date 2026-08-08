import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = "";
  bool isLoading = false;

  static const String _lottieUrl =
      "https://lottie.host/e07d0892-9978-421e-92aa-f50d2e0177ef/Wl6q7FESA7.json";

  late final Widget _lottieWidget = Lottie.network(
    _lottieUrl,
    fit: BoxFit.contain,
    frameRate: FrameRate.max,
  );

  static const Color _brandGreen = Color(0xff25D366);

  Future<void> _onContinuePressed() async {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter mobile number")),
      );
      return;
    }

    // Debug print – check Logcat / console
    print("Sending OTP to → $phoneNumber");

    setState(() {
      isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    await authProvider.authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPPage(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      },
      verificationFailed: (error) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : _onContinuePressed,
        child: isLoading
            ? const SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : const Text(
          "Continue",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _phoneField() {
    return IntlPhoneField(
      initialCountryCode: "LK",
      decoration: InputDecoration(
        labelText: "Mobile Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: Colors.white,
        searchFieldPadding: const EdgeInsets.symmetric(horizontal: 12),
        searchFieldInputDecoration: InputDecoration(
          hintText: "Search country",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _brandGreen),
          ),
        ),
        listTilePadding: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
      ),
      disableLengthCheck: true,
      showDropdownIcon: true,
      flagsButtonPadding: const EdgeInsets.only(left: 8),
      dropdownIconPosition: IconPosition.trailing,
      onChanged: (PhoneNumber phone) {
        phoneNumber = phone.completeNumber; // already gives +94...
      },
    );
  }

  Widget _content() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Welcome",
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
          _phoneField(),
          const SizedBox(height: 40),
          _buildButton(),
          const SizedBox(height: 25),
          const Text(
            "You will receive an SMS verification code.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 50),
          SizedBox(
            height: 200,
            width: 200,
            child: RepaintBoundary(child: _lottieWidget),
          ),
          const SizedBox(height: 20),
          _content(),
        ],
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: const Color(0xffF5F9F6),
            child: Center(
              child: SizedBox(
                height: 360,
                width: 360,
                child: RepaintBoundary(child: _lottieWidget),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: _content(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return _buildWebLayout();
            }
            return _buildMobileLayout();
          },
        ),
      ),
    );
  }
}