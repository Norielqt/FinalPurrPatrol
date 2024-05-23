import 'package:flutter/material.dart';
import 'package:purrpatrol/screens/loginscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purr Patrol App',
      home: const WelcomePage(),
      routes: {
        '/loginPage': (BuildContext ctx) => const LoginPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Color
          Container(
            color: const Color(0xFFFFF96B),
          ),
          // Logo
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/loginPage');
              },
              child: Image.network(
                'https://scontent.fmnl4-8.fna.fbcdn.net/v/t1.15752-9/438267641_971823761016558_3357918758099394369_n.png?_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeFl9JvG8pJJQ_A-9qbsh2ciAAFgqwwUHmMAAWCrDBQeY183HUe8IVH3a4TVHKzQiI-XCnje1NHcJnjATJxdjK39&_nc_ohc=hyi2yQ69yfMQ7kNvgG6dj-f&_nc_ht=scontent.fmnl4-8.fna&oh=03_Q7cD1QG6x18dtO4XXYI8gGwpXRplXN-0djkwI6_ynTYFSewigQ&oe=6667C3E0',
                height: 600, // Adjust the height here
              ),
            ),
          ),
        ],
      ),
    );
  }
}