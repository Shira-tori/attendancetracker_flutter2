import 'package:attendancetracker_flutter2/providers/cameratabprovider.dart';
import 'package:attendancetracker_flutter2/providers/loginprovider.dart';
import 'package:attendancetracker_flutter2/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider(),),
      ChangeNotifierProvider(create: (_) => ScannerProvider(),),
    ],
    child: const MainApp(),),);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
