import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/component/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Initial properties
  double _width = 100;
  double _height = 100;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  // Method to change properties
  void _animateContainer() {
    setState(() {
      // Toggle between two states
      _width = _width == 100 ? 200 : 100;
      _height = _height == 100 ? 200 : 100;
      _color = _color == Colors.grey ? Colors.red : Colors.grey;
      _borderRadius = _borderRadius == BorderRadius.circular(8)
          ? BorderRadius.circular(50)
          : BorderRadius.circular(8);
    });
  }

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Welcome to home page',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 3),
              curve: Curves.easeInOut,
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: _borderRadius,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _animateContainer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent, // Button background color
              foregroundColor: Colors.white, // Text color
            ),
            child: Text("click"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          signout();
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
