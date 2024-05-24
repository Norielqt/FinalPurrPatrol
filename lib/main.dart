import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:purrpatrol/screens/loginscreen.dart';
import 'package:purrpatrol/screens/welcomescreen.dart';
import 'package:flutter/material.dart';
import 'package:purrpatrol/components/home_drawer.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyD-Q2XTKS0EIxpX79_M_xzIhxzQqaurxVQ", 
                                                          appId: "1:431814770090:web:352087a06cd9f96b307fd3", 
                                                          messagingSenderId: "431814770090", 
                                                          projectId: "purr-patrol"));
  }
  
  runApp(const MainApp());
}


  
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purr Patrol App',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/welcomeScreen': (BuildContext ctx) => const WelcomePage(),
        '/loginPage': (BuildContext ctx) => const LoginPage(),
        '/homeScreen': (BuildContext ctx) => const HomeScreen(),
      },
      initialRoute: '/welcomeScreen',
    );
  }
}




