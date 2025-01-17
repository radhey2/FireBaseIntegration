import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/component/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      showMessage('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Welcome to home page',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text('Welcome to home page',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signout();
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
