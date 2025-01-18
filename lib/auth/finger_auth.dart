import 'package:firebase_project/component/home_page.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class FingureAuth extends StatefulWidget {
  const FingureAuth({super.key});

  @override
  State<FingureAuth> createState() => _FingureAuthState();
}

class _FingureAuthState extends State<FingureAuth> {
  final LocalAuthentication auth = LocalAuthentication();

  checkAuth() async {
    bool isAvailable;

    isAvailable = await auth.canCheckBiometrics;
    if (isAvailable) {
      bool result =
          await auth.authenticate(localizedReason: ('scan your fingure'));
      if (result) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        showMessage('Permission denied');
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biomertic Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Lottie.asset('assets/Animation/figureAuth.json',
                height: 180, width: 150),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  checkAuth();
                },
                child: Text('Authenticate'))
          ],
        ),
      ),
    );
  }
}
