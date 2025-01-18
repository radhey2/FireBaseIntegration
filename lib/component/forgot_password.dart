import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/component/login_page.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  forgotPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      showMessage('If the email is registered, a reset link will be sent.');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      showMessage("Email is not registered");
    } finally {
      setState(() {
        isLoading = false;
      });
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
        title: Text('Login Page'),
      ),
      body: Column(
        children: [
          TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  suffix: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)))),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () {
                    forgotPassword();
                  },
                  child: Text('Reset password')),
        ],
      ),
    );
  }
}
