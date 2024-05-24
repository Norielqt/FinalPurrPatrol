import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:purrpatrol/components/home_drawer.dart';
import 'package:purrpatrol/screens/loginscreen.dart';
import 'package:purrpatrol/components/calebot_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const AddPurr());
}

class AddPurr extends StatelessWidget {
  const AddPurr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String category2 = '';
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  

  DateTime _selectedDate = DateTime.now();

   Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  void _addData() async {
    String title = _titleController.text;
    String weight = _weightController.text;
    String color = _colorController.text;
    String date = _dateController.text;
    String location = _locationController.text;
    String breed = _breedController.text;
    String phone = _phoneController.text;
    String sex = category2;
    String type;

    if (_titleController.text.contains('Dog')) {
      type = 'https://scontent.fklo1-1.fna.fbcdn.net/v/t1.15752-9/344282563_693059255956988_5504602844254965475_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHVCKGdcGiZxEcuj_pYnyI5BV1Ay3i_DwUFXUDLeL8PBYG2L12mq-dxnIr6Aki8TtflmwUP58gqeVOlp6Yhb85t&_nc_ohc=rUhq0vZDP8EQ7kNvgHvd0kD&_nc_ht=scontent.fklo1-1.fna&oh=03_Q7cD1QHRGLlmymNkS9HBdvdepOP_uThdgELzdrxv8yv1SzOgrw&oe=66771810';
    }
    else{
      type = 'https://scontent.xx.fbcdn.net/v/t1.15752-9/368062596_1045356893172705_462659872860581481_n.jpg?stp=dst-jpg_p206x206&_nc_cat=111&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeH_2_YQlZSuPscANkLoJNMcKzSolyfbZEYrNKiXJ9tkRm9D6t89eIa_R_MfaI8JET0VSvw-_Dk4iWoBzwKKzKEw&_nc_ohc=KmVKvFSKZmYQ7kNvgEnapTp&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_Q7cD1QEzRniiRa4xf8FIp9Evz466dueUuYFZityjZGT3zWSGrQ&oe=66773489';
    }

    CollectionReference pets = _firestore.collection('pets');

    await pets.add({
      'title': title,
      'weight': weight,
      'color': color,
      'date': date,
      'location': location,
      'breed': breed,
      'phone': phone,
      'sex': sex,
      'type' : type,
    }).then((value) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pet Added'),
            content: Text('Pet added successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()));
                },
              ),
            ],
          );
        },
      )
      ).catchError((error) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add pet: $error'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      )
    );
    
  }

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Purr',
          style: TextStyle(color: Colors.black,),
        ),
        backgroundColor:  Colors.white,
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
   body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: [
                      if (_image != null)
                        Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                          width: double.infinity, // Ensures the image covers the entire container
                          height: 200, // Ensures the image height matches the container height
                        ),
                      const Center(
                        child: Text(
                          'Add a photo (optional)',
                          style: TextStyle(
                            color: Colors.black, // Adjust color for better visibility
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: 'Color',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            

            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Enter Date",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true, // Prevents user from typing manually
              onTap: () {
                _selectDate(context);
              }
            ),


            

              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _breedController,
                decoration: InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0), // Add padding around the ChoiceChip
                    child: ChoiceChip(
                      label: Container(
                        height: 40,
                        width: 50,
                        alignment: Alignment.center,
                        child: const Text('Male'),
                      ),
                      selected: category2 == 'Male',
                      selectedColor: Color(0xFFFFF96B),
                      onSelected: (bool selected) {
                        setState(() {
                          category2 = selected ? 'Male' : 'Female';
                        });
                      },
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Add padding around the ChoiceChip
                    child: ChoiceChip(
                      label: Container(
                        height: 40,
                        width: 50,
                        alignment: Alignment.center,
                        child: const Text('Female'),
                      ),
                      selected: category2 == 'Female',
                      selectedColor: Color(0xFFFFF96B),
                      onSelected: (bool selected) {
                        setState(() {
                          category2 = selected ? 'Female' : 'Male';
                        });
                      },
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addData,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Post'),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize:const Size(100, 30),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              Icon(icon, color: Colors.black,),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(color: Colors.black,)),
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

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,  // Enlarged size of the circle
                  height: 200, // Enlarged size of the circle
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFF96B),
                  ),
                  child: Align(
                    alignment: Alignment(0.4, 0.2),
                    child: Image.network(
                      'https://scontent.fmnl4-8.fna.fbcdn.net/v/t1.15752-9/438267641_971823761016558_3357918758099394369_n.png?_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeFl9JvG8pJJQ_A-9qbsh2ciAAFgqwwUHmMAAWCrDBQeY183HUe8IVH3a4TVHKzQiI-XCnje1NHcJnjATJxdjK39&_nc_ohc=hyi2yQ69yfMQ7kNvgG6dj-f&_nc_ht=scontent.fmnl4-8.fna&oh=03_Q7cD1QG6x18dtO4XXYI8gGwpXRplXN-0djkwI6_ynTYFSewigQ&oe=6667C3E0',
                      fit: BoxFit.cover,
                      width: 950, // Adjust image size as needed
                      height:950, // Adjust image size as needed
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1, // Adjust position of the icon as needed
                  right: 25, // Adjust position of the icon as needed
                  child: Icon(
                    Icons.verified,
                    color: Colors.black,
                    size: 40, // Adjust size of the icon as needed
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Spacing between the circle and the text
            Text(
              'Your post was successfully published!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
