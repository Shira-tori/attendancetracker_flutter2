// ignore_for_file: use_build_context_synchronously

import 'package:attendancetracker_flutter2/providers/cameratabprovider.dart';
import 'package:attendancetracker_flutter2/providers/loginprovider.dart';
import 'package:attendancetracker_flutter2/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
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
                                context.read<LoginProvider>().setDisabled();
                                context.read<LoginProvider>().setButtonChild();
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
                                  for (var row in result) {
                                    context
                                        .read<ScannerProvider>()
                                        .setTeacherId(row[5]);
                                    context
                                        .read<ScannerProvider>()
                                        .setAbsentees();
                                    context
                                        .read<ScannerProvider>()
                                        .setUser(row[0]);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const HomeScreen(),
                                        ),
                                        (route) => false);
                                  }
                                }
                                db.close();
                              },
                              child: context.watch<LoginProvider>().buttonChild,
                            ),
                          ),
                        ),
                      ],
                    )
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
