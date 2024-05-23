import 'package:purrpatrol/components/home_drawer.dart';
import 'package:purrpatrol/firebase_auth_implementation/firebase_auth.services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purrpatrol/screens/loginscreen.dart';


void main() {
  runApp(const SignUp());
}

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purr Patrol App',
      home: const LoginPage(),
      routes: {
        '/homeScreen': (BuildContext ctx) => const  HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose(){
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Color
          Container(
            color: const  Color(0xFFFFF96B),
          ),


          Positioned(
          top: 0,
          left: 0,
          right: 420,
          height: 50,
          child: IconButton(
            onPressed: () {
              print("Login button pressed"); // Add this line for debugging
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainApp()),
                  );
            },
            icon:   const Icon(
              Icons.arrow_back,
              color: Color(0xFF121212), // Set icon color
            ),
          ),
        ),

          // Welcome Text
          const  Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Text.rich(
              TextSpan(
                text: 'Registration',
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Username Input
          Positioned(
            top: 300,
            left: 50,
            right: 50,
            height: 50,
            child: TextFormField(
              controller: _usernameController,
              style: const  TextStyle(color: Color(0xFF121212)), // Set text color
              decoration: InputDecoration(
                hintText: 'Username',
                hintStyle: const  TextStyle(color: Color(0xFF9E9E9E)),
                prefixIcon: const Icon(
                  Icons.people,
                  color: Color(0xFF121212), // Set icon color
                ),
                filled: true,
                fillColor: Colors.white, // Set background color
                enabledBorder: OutlineInputBorder(
                  borderSide: const  BorderSide(color: Color(0xFF121212)),
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF121212)),
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0), // Set vertical padding
              ),
            ),
          ),
          // Email Input
          Positioned(
            top: 370,
            left: 50,
            right: 50,
            height: 50,
            child: TextFormField(
              controller: _emailController,
              style: const  TextStyle(color: Color(0xFF121212)), // Set text color
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const  TextStyle(color: Color(0xFF9E9E9E)),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Color(0xFF121212), // Set icon color
                ),
                filled: true,
                fillColor: Colors.white, // Set background color
                enabledBorder: OutlineInputBorder(
                  borderSide: const  BorderSide(color: Color(0xFF121212)),
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF121212)),
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0), // Set vertical padding
              ),
            ),
          ),
          // Password Input
          Positioned(
            top: 440,
            left: 50,
            right: 50,
            height: 50,
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Color(0xFF121212)), // Set text color
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const  TextStyle(color: Color(0xFF9E9E9E)),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xFF121212), // Set icon color
                ),
                filled: true,
                fillColor: Colors.white, // Set background color
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF121212)),
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const  BorderSide(color: Color(0xFF121212)),
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0), // Set vertical padding
              ),
            ),
          ),
          // Submit Button
          Positioned(
            bottom: 150,
            left: 125,
            right: 115,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _signUp, 
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const   Color(0xFF121212),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const  BorderSide(color: Color(0xFF121212)),
                  ),
                ),
                child: const  Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Successful'),
            content: Text('User is successfully created'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Dismiss the dialog and then navigate
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/loginPage");
                },
              ),
            ],
          );
        },
      );
      print("User is successfully created");
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Try Again'),
            content: Text('Please Check Your Information'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Dismiss the dialog and then navigate
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print("Some error happened");
    }
  }
}


 
