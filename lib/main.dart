import 'package:flutter/material.dart';
import 'package:git_practice/home_page.dart';
import 'package:git_practice/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: prefs.getString("token") != null ? HomePage() : Login(),
    ),
  );
}