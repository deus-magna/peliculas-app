import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/screens/forgot_password_screen.dart';

import 'package:peliculas/src/screens/home_screen.dart';
import 'package:peliculas/src/screens/login_screen.dart';
import 'package:peliculas/src/screens/movie_detail_screen.dart';
import 'package:peliculas/src/screens/register_screen.dart';
 
final FirebaseAuth _auth = FirebaseAuth.instance;
 
void main() async {

  final FirebaseUser user = await _auth.currentUser();
  final route = user != null? 'home':'login';
  runApp(MyApp(route: route));
}
 
class MyApp extends StatelessWidget {

  // Ruta a donde debe ir el app
  final String route;
  
  // Constructor
  MyApp({@required this.route});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.red,
      ),
      title: 'Peliculas',
      initialRoute: route,
      routes: {
        'login' : (BuildContext context) => LoginScreen(),
        'register' : (BuildContext context) => RegisterScreen(),
        'home' : (BuildContext context) => HomeScreen(),
        'detalle' : (BuildContext context) => MovieDetailScreen(),
        'password' : (BuildContext context) => ForgotPasswordScreen(),
      },
    );
  }
}