import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'PdfFirebase/FirstPage.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  //const MyApp({super.key});

  // This widget is the root of your application.
  @override
Widget build(BuildContext context) {  
    return FutureBuilder(  
      // Initialize FlutterFire:  
  future: _initialization,  
      builder: (context, snapshot) {  
        // Check for errors  
  if (snapshot.hasError) {  
          return Text('Error in Firebase Initilisation');  
        }  
        // Once complete, show your application  
  if (snapshot.connectionState == ConnectionState.done) {  
          return MaterialApp(  
            title: 'College App',  
            home: new Scaffold(body: new FirstPage(),),  
          );  
        }  
        // Otherwise, show something whilst waiting for initialization to complete  
  return CircularProgressIndicator();  
      },  
    );  
  }  
}

class HomeWidget extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
    //return Container();
  }
}
