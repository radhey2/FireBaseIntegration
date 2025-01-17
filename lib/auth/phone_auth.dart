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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Enter your phone',
                suffix: Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24))),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted: (PhoneAuthCredential credentials) {},
                    verificationFailed: (FirebaseException ex) {},
                    codeSent: (String verificationId, int? resendToken) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                    verificationId: verificationId,
                                  )));
                    },
                    codeAutoRetrievalTimeout: (String verificationid) {},
                    phoneNumber: phoneController.text.toString());
              },
              child: Text('Verify Phone'))
        ],
      ),
    );
  }
}
