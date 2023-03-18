import 'package:attendancetracker_flutter2/providers/loginprovider.dart';
import 'package:attendancetracker_flutter2/screens/attendancetab.dart';
import 'package:attendancetracker_flutter2/screens/cameratab.dart';
import 'package:attendancetracker_flutter2/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cameratabprovider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF416E8E),
            title: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                  height: 70,
                  width: 200,
                  child: Wrap(children: const [
                    Image(
                      image: AssetImage(
                        'images/attendify.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ])),
            ),
            titleTextStyle:
                const TextStyle(fontSize: 25, fontFamily: "Muli-Bold"),
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.black,
              indicator: const BoxDecoration(color: Color(0xFFCBF7ED)),
              tabs: <Widget>[
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.home),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Tracker')
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Scanner')
                    ],
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            backgroundColor: const Color(0xFF416E8E),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 200,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/drawerbg.jpg"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Color(0xFF416E8E), BlendMode.darken)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.blue.shade900,
                                    child: Text(
                                        context.read<ScannerProvider>().user[0],
                                        style: const TextStyle(fontSize: 50)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        context.read<ScannerProvider>().user,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Muli-Bold",
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.white),
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Muli-Bold"),
                        ),
                        onTap: () {
                          context.read<ScannerProvider>().reset();
                          context.read<LoginProvider>().setButtonChildNormal();
                          context.read<LoginProvider>().setFailedFalse();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AttendanceTab(),
              ScannerTab(),
            ],
          ),
        ),
      ),
    );
  }
}
