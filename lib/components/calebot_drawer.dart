import 'package:purrpatrol/components/chronoroom_drawer.dart';
import 'package:purrpatrol/components/home_drawer.dart';
import 'package:purrpatrol/screens/loginscreen.dart';
import 'package:flutter/material.dart';

class MyListPage extends StatelessWidget {
  const MyListPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('My Reports'),
        backgroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: Container(
           color: Color(0xFFFFF96B),
          child: ListView(
            children: <Widget>[
              Container(
                height: 80,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                   color: Color(0xFFFFF96B),
                ),
                child: const Text(
                  'Purr Patrol',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              _buildHoverableDrawerItem('Home', Icons.home, () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              }),
             
              _buildHoverableDrawerItem('My Reports', Icons.chat, () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const MyListPage()));
              }),
              _buildHoverableDrawerItem('Logout', Icons.exit_to_app, () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoginPage()));
              }),
            ],
          ),
        ),
      ),
        body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 120),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F2F6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const ItemWidget2(
                  imageUrl: '',
                  headerText: 'Cute Corgi Dog',
                  subtitleText: '4-5 kgs',
                  additionalText: 'Brown',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your functionality here
                      },
                      child: const Text('Button 1'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your functionality here
                      },
                      child: const Text('Button 2'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your functionality here
                      },
                      child: const Text('Button 3'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





  Widget _buildHoverableDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: ListTile(
            title: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }

 

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}