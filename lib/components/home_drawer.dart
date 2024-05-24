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
  String searchQuery = '';

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
      Map<String, dynamic> petData = doc.data() as Map<String, dynamic>;
      petData['id'] = doc.id; // Add the document ID to the pet data
      pets.add(petData);
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      pets = pets.where((pet) {
        // Filter based on the 'title' field
        return pet['title'].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return pets;
  } catch (e) {
    print('Error fetching pets: $e');
    throw e;
  }
}


 

  int _selectedIndex = 0;

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
              backgroundImage: NetworkImage(
                  'https://scontent.fklo1-1.fna.fbcdn.net/v/t39.30808-6/336732103_551687143482897_5025030786536306662_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGLOjdo9tsT6E6XoLnun3uOw8aqXYGglrfDxqpdgaCWt86alSzLTy8HqcZfuAHpQ2nhpncKy4XUsAuQWDCZz9l9&_nc_ohc=3zXcItAHxXwQ7kNvgEEHOAY&_nc_ht=scontent.fklo1-1.fna&oh=00_AYDiuWmRo3XWzY2--iiXkDJJG9pibr4W4-JPa7qBfbQnMg&oe=66556CA6'),
            ),
            const SizedBox(width: 25),
          ],
        ),
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
              _buildHoverableDrawerItem('Logout', Icons.exit_to_app, () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoginPage()));
              }),
            ],
          ),
        ),
      ),
    body: Stack(
  children: [
    Container(
      color: const Color(0xFFFFF96B),
    ),
    const Positioned(
            top: 20,
            left: 10,
            right: 290,
            child: Column(
              children: [
                Text(
                  "Let's find your pet...",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121212),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
    Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE7E7E7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                // Update petsFuture with the new search query
                petsFuture = fetchPetsFromFirestore();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    ),
    Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        margin: const EdgeInsets.only(top: 180),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF96B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: petsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> pets = snapshot.data!;
              // Filter pets based on searchQuery
              if (searchQuery.isNotEmpty) {
                pets = pets.where((pet) {
                  return pet['title'].toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();
              }
              return ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                id: pets[index]['id'],
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
                          imageUrl: pets[index]['type'],
                          headerText: pets[index]['title'],
                          subtitleText: pets[index]['weight'],
                          additionalText: pets[index]['color'],
                        ),
                      ),
                      Divider(
                        color: Colors.transparent,
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    ),
    Positioned(
      bottom: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPurr()),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), // Circular shape
          elevation: 8, // Add elevation
          backgroundColor: Colors.black,
          padding: const EdgeInsets.all(16),
          animationDuration: Duration(milliseconds: 200), // Add animation duration
        ),
        child: Tooltip(
          message: 'Add Purr', // Tooltip message
          child: Icon(Icons.add, color: Colors.white), // Set icon color to white
        ),
      ),
    ),
  ],
),

    );
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

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
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
  final String id;
  final String imageUrl;
  final String headerText;
  final String subtitleText;
  final String additionalText;
  final String dateLost;
  final String location;
  final String breed;
  final String sex;

  const ResultPage({
    required this.id,
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

  Future<void> deletePet(String id) async {
  try {
    await FirebaseFirestore.instance.collection('pets').doc(id).delete();
    print('Pet deleted successfully.');
  } catch (e) {
    print('Error deleting pet: $e');
    throw e;
  }
}

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
                'https://scontent.xx.fbcdn.net/v/t1.15752-9/444759941_432066073019707_1643882413514114918_n.png?stp=dst-png_p403x403&_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeE3FGyDlguHdvxc40Vb5dbbKV-M57dcyaApX4znt1zJoKcAnZPUAcdRwcBk0qIMHsN0TY0ARlVwWNbCbRaYu343&_nc_ohc=RMFw_SLpKtkQ7kNvgHZk-zj&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_Q7cD1QG5hNI2FlSQYhHy21-TPIPZ62VR8ouEf9ZSWKkg4BTdOA&oe=66779C27',
                height: 150,
                width: 150,
              ),
               IconButton(
              onPressed: () {
                      Navigator.of(context).pop();
              },
              icon: const Icon(Icons.call_end, color:  Colors.red),
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
    backgroundColor: Colors.grey[200],
    appBar: AppBar(
      title: const Text('Result'),
      backgroundColor:Colors.grey[200], // Change this to your desired color
      ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         Padding(
  padding: const EdgeInsets.only(top: 20.0),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.network(
      widget.imageUrl,
      width: 250,
      height: 250,
      alignment: Alignment.center,
    ),
  ),
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
                                foregroundColor: isCallHovered ? Color(0xFFFFF96B) : const Color(0xFF121212),
                                backgroundColor: isCallHovered ? const Color(0xFF121212) : const Color(0xFFFFF96B),
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
                              onPressed: () async {
                                bool? confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text('Are you sure you found the pet?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete == true) {
                                  await deletePet(widget.id);
                                   showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Great Job!'),
                                        content: Text('Thank You for finding this pet!'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              // Dismiss the dialog and then navigate
                                              Navigator.of(context).pop();
                                              Navigator.pushNamed(context, "/homeScreen");
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  print("User is successfully created");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: isMarkAsFoundHovered ? Color(0xFFFFF96B) : const Color(0xFF121212),
                                backgroundColor: isMarkAsFoundHovered ? const Color(0xFF121212) : const Color(0xFFFFF96B),
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