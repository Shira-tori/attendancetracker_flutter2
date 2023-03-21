// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:Attendify/providers/cameratabprovider.dart';
import 'package:Attendify/providers/loginprovider.dart';
import 'package:Attendify/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg2.jpg"), fit: BoxFit.cover),
          ),
          child: Container(
            color: const Color(0xFF1C4274).withOpacity(0.6),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 50,
                        color: Color(0xFFFCCB01),
                        fontFamily: "Muli-Bold",
                      ),
                    ),
                    const Text(
                      "Log in to your account",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFBFDFF5),
                        fontFamily: "Muli-Bold",
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: TextField(
                        controller: usernameController,
                        style: const TextStyle(
                            color: Color(0xFFBFDFF5), fontFamily: "Muli-Bold"),
                        decoration: const InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(
                            fontFamily: "Muli-Bold",
                            color: Color(0xFFBFDFF5),
                          ),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Color(0xFFFCCB01),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFBFDFF5),
                              width: 3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFBFDFF5),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: TextField(
                        controller: passwordController,
                        style: const TextStyle(
                            color: Color(0xFFBFDFF5), fontFamily: "Muli-Bold"),
                        obscureText:
                            context.watch<LoginProvider>().showPassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            fontFamily: "Muli-Bold",
                            color: Color(0xFFBFDFF5),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.key,
                              color: Color(0xFFFCCB01),
                            ),
                            onPressed: () {
                              Provider.of<LoginProvider>(context, listen: false)
                                  .showsPassword();
                            },
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFBFDFF5),
                              width: 3,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFBFDFF5),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 35.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFFCCB01),
                                ),
                              ),
                              onPressed: () async {
                                context.read<LoginProvider>().setButtonChild();
                                try {
                                  MySqlConnection db =
                                      await MySqlConnection.connect(
                                          ConnectionSettings(
                                              host: 'sql6.freemysqlhosting.net',
                                              user: 'sql6588996',
                                              db: 'sql6588996',
                                              password: 'S9DPyTQx87'));
                                  var result = await db.query(
                                      'SELECT fullname, username, password, role_id, users_tbl.user_id, flutter_teachers_tbl.teacher_id FROM users_tbl INNER JOIN flutter_teachers_tbl ON flutter_teachers_tbl.user_id = users_tbl.user_id WHERE username = "${usernameController.text}" AND password = "${passwordController.text}"');
                                  if (result.isNotEmpty) {
                                    Directory directory =
                                        await getApplicationSupportDirectory();
                                    for (var row in result) {
                                      context
                                          .read<ScannerProvider>()
                                          .setTeacherId(row[5]);
                                      await context
                                          .read<ScannerProvider>()
                                          .setAbsentees();
                                      context
                                          .read<ScannerProvider>()
                                          .setUser(row[0]);
                                      if (File(
                                              "${directory.path}/${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}::${context.read<ScannerProvider>().teacherid}.txt")
                                          .existsSync()) {
                                        List<String> text = await File(
                                                "${directory.path}/${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}::${context.read<ScannerProvider>().teacherid}.txt")
                                            .readAsLines();
                                        for (var j in text[0].split(',')) {
                                          try {
                                            if (j.split('::')[0] == "") {continue;}
                                            context
                                                .read<ScannerProvider>()
                                                .namesOfStudent
                                                .add(j.split('::')[0]);
                                            context
                                                .read<ScannerProvider>()
                                                .timeOfScan
                                                .add(j.split('::')[1]);
                                            context
                                                .read<ScannerProvider>()
                                                .absentees
                                                .remove(j.split('::')[0]);
                                          } catch (e) {
                                            continue;
                                          }
                                        }
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const HomeScreen(),
                                          ),
                                          (route) => false);
                                    }
                                  } else {
                                    context.read<LoginProvider>().setFailed();
                                    context
                                        .read<LoginProvider>()
                                        .setButtonChildNormal();
                                  }

                                  db.close();
                                } catch (e) {
                                  print(e);
                                  context.read<LoginProvider>().setFailed();
                                  context
                                      .read<LoginProvider>()
                                      .setButtonChildNormal();
                                }
                              },
                              child: context.watch<LoginProvider>().buttonChild,
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.watch<LoginProvider>().failed == true
                        ? const Text(
                            "An error has occured. Check your internet connection",
                            style: TextStyle(
                                color: Colors.red, fontFamily: "Muli-Bold"),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
