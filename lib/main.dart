import 'package:flutter/material.dart';
import 'package:kopbrewcrew/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kopbrewcrew/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:kopbrewcrew/models/user.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyAL1kfiGcOzydm3TMNV2-1qRk9hMpVgAWA',
    appId: '1:670906934854:android:1f0bf90ea9dfbdfa16cc47',
    messagingSenderId: '670906934854',
    projectId: 'kop-brew-crew',
  );

  await Firebase.initializeApp(options : firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      catchError: (_,__) {},
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
