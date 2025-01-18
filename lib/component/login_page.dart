import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/auth/finger_auth.dart';
import 'package:firebase_project/auth/phone_auth.dart';
import 'package:firebase_project/component/forgot_password.dart';
import 'package:firebase_project/component/home_page.dart';
import 'package:firebase_project/component/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isLoading = false;

  // Method for user login
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Please enter both email and password.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showMessage("Login successful!");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      // Navigate to the home page or main app screen here
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format.";
          break;
        default:
          errorMessage = "An error occurred: ${e.message}";
      }
      showMessage(errorMessage);
    } catch (e) {
      showMessage("An unexpected error occurred.");
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

  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? accounts = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication userAccount =
          accounts!.authentication as GoogleSignInAuthentication;

      final credentials = GoogleAuthProvider.credential(
          accessToken: userAccount.accessToken, idToken: userAccount.idToken);

      await FirebaseAuth.instance.signInWithCredential(credentials);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      showMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Stack(
        children: [
          // Main content of the screen
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email',
                      suffixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      suffixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : login,
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            );
                          },
                    child: const Text('Forgot Password?'),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()),
                            );
                          },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text('-----sign in using below method-----'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: isLoading ? null : loginWithGoogle,
                          icon: const Icon(
                            Icons.g_mobiledata_sharp,
                            size: 50.0,
                          )),
                      IconButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhoneAuth()),
                                  );
                                },
                          icon: const Icon(Icons.phone)),
                      IconButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FingureAuth()),
                                  );
                                },
                          icon: const Icon(Icons.fingerprint))
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
