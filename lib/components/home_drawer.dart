import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purrpatrol/components/chronoroom_drawer.dart';
import 'package:purrpatrol/screens/loginscreen.dart';
import 'package:purrpatrol/components/calebot_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}




class _HomeScreenState extends State<HomeScreen> {

  late Future<List<Map<String, dynamic>>> petsFuture;

  @override
  void initState() {
    super.initState();
    petsFuture = fetchPetsFromFirestore();
  }

  Future<List<Map<String, dynamic>>> fetchPetsFromFirestore() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pets')
        .orderBy('date', descending: false)
        .get();

    List<Map<String, dynamic>> pets = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      pets.add(doc.data() as Map<String, dynamic>);
    }

    return pets;
  } catch (e) {
    print('Error fetching pets: $e');
    throw e;
  }
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFFFF96B),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFF121212),
                size: 28,
              ),
              onPressed: () {
                // Handle notification icon tap
              },
            ),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage('https://scontent.fklo1-1.fna.fbcdn.net/v/t39.30808-6/336732103_551687143482897_5025030786536306662_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGLOjdo9tsT6E6XoLnun3uOw8aqXYGglrfDxqpdgaCWt86alSzLTy8HqcZfuAHpQ2nhpncKy4XUsAuQWDCZz9l9&_nc_ohc=3zXcItAHxXwQ7kNvgEEHOAY&_nc_ht=scontent.fklo1-1.fna&oh=00_AYDiuWmRo3XWzY2--iiXkDJJG9pibr4W4-JPa7qBfbQnMg&oe=66556CA6'),
            ),
            const SizedBox(width: 25),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFFFF96B),
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF96B),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Purr Patrol',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              _buildHoverableDrawerItem('Home', Icons.home, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }),
              _buildHoverableDrawerItem('Add Purr', Icons.access_time, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPurr()),
                );
              }),
              _buildHoverableDrawerItem('My Reports', Icons.chat, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyListPage()),
                );
              }),
              _buildHoverableDrawerItem('Logout', Icons.exit_to_app, () async {
                await FirebaseAuth.instance.signOut();
                  Navigator.pop(context); 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> pets = snapshot.data!;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          imageUrl: pets[index]['type'], 
                          headerText: pets[index]['title'],
                          subtitleText: pets[index]['weight'],
                          additionalText: pets[index]['color'],
                          dateLost: pets[index]['date'],
                          location: pets[index]['location'],
                          breed: pets[index]['breed'],
                          sex: pets[index]['sex'],
                        ),
                      ),
                    );
                  },
                  child: ItemWidget2(
                    imageUrl: pets[index]['type'], // Placeholder image URL
                    headerText: pets[index]['title'], // Placeholder text until data is fetched
                    subtitleText: pets[index]['weight'],
                    additionalText: pets[index]['color'],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
  Widget _buildHoverableDrawerItem(
      String title, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: ListTile(
            title: Row(
              children: [
                Icon(icon, color: const Color(0xFF121212)),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(color: Color(0xFF121212))),
              ],
            ),
          ),
        ),
      ),
    );
  }


class ItemWidget2 extends StatelessWidget {
  final String imageUrl;
  final String headerText;
  final String subtitleText;
  final String additionalText;

  const ItemWidget2({
    required this.imageUrl,
    required this.headerText,
    required this.subtitleText,
    required this.additionalText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350, // Adjusted width of the container
      height: 170, // Adjusted height of the container
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the top
        children: [
          Container(
            width: 120, // Width of the image container
            height: double.infinity, // Full height of the container
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Border radius of image container
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Border radius of image
              child: Image.network(
                imageUrl, // Image URL
                width: 120, // Adjust width of the image
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20), // Add some spacing between the image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50), // Add vertical padding
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    headerText, // Header text
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 5), // Add some vertical spacing
                Text(
                  subtitleText, // Subtitle text
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                Text(
                  additionalText, // Another line of text
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  final String imageUrl;
  final String headerText;
  final String subtitleText;
  final String additionalText;
  final String dateLost;
  final String location;
  final String breed;
  final String sex;

  const ResultPage({
    required this.imageUrl,
    required this.headerText,
    required this.subtitleText,
    required this.additionalText,
    required this.dateLost,
    required this.location,
    required this.breed,
    required this.sex,
    Key? key,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool isCallHovered = false;
  bool isMarkAsFoundHovered = false;

 void _callOwner() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Calling...',
            textAlign: TextAlign.center,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://scontent.xx.fbcdn.net/v/t1.15752-9/441083894_416066551184552_3073040650696970110_n.png?stp=dst-png_p206x206&_nc_cat=103&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEfyWiwY2nsaVx-cgDMeNrZo5TAuuCnWoKjlMC64KdagnnNB4A5UzSYH3RKCrbAyWmql19lthjMbWQNEhkeZQW_&_nc_ohc=4L8DGPa14nEQ7kNvgFTyH8-&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_Q7cD1QGBIM4Tb0xkmAlRysJsSS7fbkM77KgjC9bNeTL-fqjzFw&oe=666968C3',
                height: 200,
                width: 200,
              ),
               IconButton(
              onPressed: () {
                      Navigator.of(context).pop();
              },
              icon: const Icon(Icons.call_end, color: Colors.red),
              iconSize: 40,
            ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
              height: 250,
              width: 400,
            ), 
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.headerText,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.subtitleText,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.additionalText,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        'Date Lost: ${widget.dateLost}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Location: ${widget.location}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Breed: ${widget.breed}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sex: ${widget.sex}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  isCallHovered = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  isCallHovered = false;
                                });
                              },
                             child: ElevatedButton(
                                onPressed: _callOwner,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: isCallHovered ? Colors.white : const Color(0xFF121212), backgroundColor: isCallHovered ? const Color(0xFF121212) : const Color(0xFFF6F6F6),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.call, color: isCallHovered ? Colors.white : const Color(0xFF121212)),
                                    const SizedBox(width: 10),
                                    Text('Call', style: TextStyle(color: isCallHovered ? Colors.white : const Color(0xFF121212))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  isMarkAsFoundHovered = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  isMarkAsFoundHovered = false;
                                });
                              },
                              child: ElevatedButton(
                                onPressed: () {
                                  // Mark as found button functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: isMarkAsFoundHovered ? Colors.white : const Color(0xFF121212), backgroundColor: isMarkAsFoundHovered ? const Color(0xFF121212) : const Color(0xFFF6F6F6),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.done, color: isMarkAsFoundHovered ? Colors.white : const Color(0xFF121212)),
                                    const SizedBox(width: 10),
                                    Text('Mark as Found', style: TextStyle(color: isMarkAsFoundHovered ? Colors.white : const Color(0xFF121212))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}