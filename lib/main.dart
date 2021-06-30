import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oneplace_illinois/src/onePlace.dart';

/*
Main function that Flutter looks for when running the App. Will call the OnePlace class.
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(OnePlace());
}
