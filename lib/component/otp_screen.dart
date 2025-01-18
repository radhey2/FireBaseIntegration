import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/component/home_page.dart';
import 'package:firebase_project/main.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  verifyOtp() async {
    PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otpController.text);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } catch (e) {
      showMessage(e.toString());
    }
  }

  // Method to display messages using SnackBar
  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Page'),
      ),
      body: Column(
        children: [
          TextField(
            controller: otpController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                prefix: Text('+91'),
                hintText: 'Enter OTP',
                suffix: Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
          ElevatedButton(
              onPressed: () async {
                verifyOtp();
              },
              child: Text('OTP'))
        ],
      ),
    );
  }
}
