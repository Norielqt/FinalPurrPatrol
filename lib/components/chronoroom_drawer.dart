import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:purrpatrol/components/home_drawer.dart';
import 'package:purrpatrol/screens/loginscreen.dart';
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
      type = 'https://scontent.fceb2-2.fna.fbcdn.net/v/t1.15752-9/444761550_413314671600098_3271622928308436790_n.png?_nc_cat=102&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGXY29nVl7EI4Kq0yUT6gEUuEwvvOMsfU64TC-84yx9TkA4MOX3LA9_nwIb8ZBtGVVPcmVixlIZ0mBcYinfE_jf&_nc_ohc=cjmCXzMBXs8Q7kNvgFZkdFq&_nc_ht=scontent.fceb2-2.fna&oh=03_Q7cD1QGvLZoh0gjhmGd3MEOMWiLL7lld5OI2Y4fCvsh-GaRFsg&oe=6677CCAE';
    }
    else {
      type = 'https://scontent.fmnl13-2.fna.fbcdn.net/v/t1.15752-9/444760945_1221425379223396_162889497798784_n.png?_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEw1duUT1L4jRJalfTuLWom7MRuQGYw_1XsxG5AZjD_VdQG5F8cmCZWTfVVoHtvmF4HTLnYZdMSX3sOQWp4q7li&_nc_ohc=glXMBeiBZScQ7kNvgGI6qd-&_nc_ht=scontent.fmnl13-2.fna&oh=03_Q7cD1QEqEHLPrDaPlITXkKHP6DDJHYTLCoTuNpuzjhFrnK4T1w&oe=6677C03A';
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
            content: Text('Report added successfully!'),
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
        backgroundColor:  Color(0xFFFFF96B),
      ),
     
       drawer: Drawer(
        child: Container(
           color: const Color(0xFFFFF96B),
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
                labelText: "Select Date",
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
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(100, 30),
    foregroundColor: Colors.white,
    backgroundColor: Colors.black,
    textStyle: const TextStyle(fontSize: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      Icon(Icons.add), // Icon you want to add
      SizedBox(width: 8), // Adjust the space between icon and text
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('Post'),
      ),
    ],
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
