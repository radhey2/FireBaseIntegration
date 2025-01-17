import 'package:firebase_auth/firebase_auth.dart';
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
                hintText: 'Enter OTP',
                suffix: Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential phoneAuthCredential =
                      await PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otpController.text.toString());
                  FirebaseAuth.instance
                      .signInWithCredential(phoneAuthCredential)
                      .then((value) => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()))
                          });
                } catch (e) {}
              },
              child: Text('OTP'))
        ],
      ),
    );
  }
}
