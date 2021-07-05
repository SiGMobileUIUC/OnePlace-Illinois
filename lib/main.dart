import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oneplace_illinois/src/onePlace.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
Main function that Flutter looks for when running the App. Will call the OnePlace class.
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(OnePlace());
}
