import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/component/otp_screen.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();

  // Method to send OTP code
  sendCode() async {
    try {
      if (phoneController.text.isEmpty) {
        showMessage("Please enter a valid phone number.");
        return;
      }

      // Format the phone number with country code
      String phoneNumber = "+91${phoneController.text}";

      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber, // Provide the phone number here
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-completion of verification
          showMessage("Verification completed automatically.");
        },
        verificationFailed: (FirebaseException e) {
          // Display error message
          showMessage("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to the OTP screen with verificationId
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Code retrieval timeout
          showMessage("Code retrieval timed out.");
        },
      );
    } catch (e) {
      // Catch any other exceptions
      showMessage("Error: $e");
    }
  }

  // Method to display messages using SnackBar
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter your phone',
                // prefix: const Text('+91 '),
                suffixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendCode,
              child: const Text('Verify Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
