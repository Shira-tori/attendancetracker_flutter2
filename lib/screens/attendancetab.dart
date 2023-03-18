// ignore_for_file: use_build_context_synchronously

import 'dart:io' as io;

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:Attendify/providers/cameratabprovider.dart';
import 'package:Attendify/screens/presentscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'absentscreen.dart';
import 'masterlistscreen.dart';

class AttendanceTab extends StatelessWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/bg2.jpg"), fit: BoxFit.cover),
      ),
      child: Container(
        color: const Color(0xFF416e8e).withOpacity(0.6),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xCC22395C),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          margin: const EdgeInsets.all(30.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const PresentScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 90.0),
                                      child: Text(
                                        "PRESENT",
                                        style:
                                            TextStyle(fontFamily: "Muli-Bold"),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      child: Icon(Icons.person, size: 80)),
                                  Expanded(
                                    child: Text(
                                      context
                                          .watch<ScannerProvider>()
                                          .namesOfStudent
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: "Muli-Bold",
                                          fontSize: 40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AbsentScreen()));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Color(0xFFDB4E4E),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 90.0),
                                      child: Text(
                                        "ABSENT",
                                        style:
                                            TextStyle(fontFamily: "Muli-Bold"),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Icon(
                                      Icons.person_off,
                                      size: 80,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      context
                                          .watch<ScannerProvider>()
                                          .absentees
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: "Muli-Bold",
                                          fontSize: 40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Material(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MasterlistScreen(),
                                    ),
                                  );
                                },
                                title: const Text("Masterlist",
                                    style: TextStyle(fontFamily: "Muli-Bold")),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Material(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                              child: ListTile(
                                title: const Text(
                                  "Export to Excel",
                                  style: TextStyle(fontFamily: "Muli-Bold"),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Export"),
                                        content: const Text(
                                            "Are you sure you want to export?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              List<String> months = [
                                                "JANUARY",
                                                "FEBRUARY",
                                                "MARCH",
                                                "APRIL",
                                                "MAY",
                                                "JUNE",
                                                "JULY",
                                                "AUGUST",
                                                "SEPTEMBER",
                                                "OCTOBER",
                                                "NOVEMBER",
                                                "DECEMBER"
                                              ];
                                              io.Directory? path =
                                                  await getExternalStorageDirectory();
                                              if (io.File(
                                                      '${path!.path}/${months[DateTime.now().month - 1]}.xlsx')
                                                  .existsSync()) {
                                                Excel excel = Excel.decodeBytes(
                                                    io.File('${path.path}/${months[DateTime.now().month - 1]}.xlsx')
                                                        .readAsBytesSync());
                                                if (excel.sheets.containsValue(
                                                    '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}')) {
                                                  excel.delete(
                                                      '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}');
                                                }
                                                Sheet sheet = excel[
                                                    '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}'];
                                                sheet
                                                    .cell(
                                                        CellIndex.indexByString(
                                                            'A1'))
                                                    .value = 'PRESENT';
                                                int i = 2;
                                                for (var row in context
                                                    .read<ScannerProvider>()
                                                    .namesOfStudent) {
                                                  var cell = sheet.cell(
                                                    CellIndex.indexByString(
                                                        'A$i'),
                                                  );
                                                  cell.value = row;
                                                  var cell2 = sheet.cell(
                                                    CellIndex.indexByString(
                                                        'B$i'),
                                                  );
                                                  cell2.value = context
                                                      .read<ScannerProvider>()
                                                      .timeOfScan[i - 2];
                                                  i++;
                                                }
                                                sheet
                                                    .cell(
                                                      CellIndex.indexByString(
                                                          'C1'),
                                                    )
                                                    .value = 'ABSENT';
                                                i = 2;
                                                for (var row in context
                                                    .read<ScannerProvider>()
                                                    .absentees) {
                                                  var cell = sheet.cell(
                                                      CellIndex.indexByString(
                                                          'C$i'));
                                                  cell.value = row;
                                                  i++;
                                                }
                                                var fileBytes = excel.save();
                                                io.File(
                                                    '${path.path}/${months[DateTime.now().month - 1]}.xlsx')
                                                  ..createSync(recursive: true)
                                                  ..writeAsBytesSync(
                                                      fileBytes!);
                                                OpenFile.open(
                                                    '${path.path}/${months[DateTime.now().month - 1]}.xlsx');
                                              } else {
                                                Excel excel =
                                                    Excel.createExcel();
                                                excel.rename(
                                                    excel.getDefaultSheet()!,
                                                    '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}');
                                                Sheet sheet = excel[
                                                    '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}'];
                                                sheet
                                                    .cell(
                                                        CellIndex.indexByString(
                                                            'A1'))
                                                    .value = 'PRESENT';
                                                int i = 2;
                                                for (var row in context
                                                    .read<ScannerProvider>()
                                                    .namesOfStudent) {
                                                  var cell = sheet.cell(
                                                    CellIndex.indexByString(
                                                        'A$i'),
                                                  );
                                                  cell.value = row;
                                                  var cell2 = sheet.cell(
                                                    CellIndex.indexByString(
                                                        'B$i'),
                                                  );
                                                  cell2.value = context
                                                      .read<ScannerProvider>()
                                                      .timeOfScan[i - 2];
                                                  i++;
                                                }
                                                sheet
                                                    .cell(
                                                        CellIndex.indexByString(
                                                            'C1'))
                                                    .value = 'ABSENT';
                                                i = 2;
                                                for (var row in context
                                                    .read<ScannerProvider>()
                                                    .absentees) {
                                                  var cell = sheet.cell(
                                                      CellIndex.indexByString(
                                                          'C$i'));
                                                  cell.value = row;
                                                  i++;
                                                }
                                                var fileBytes = excel.save();
                                                io.File(
                                                    '${path.path}/${months[DateTime.now().month - 1]}.xlsx')
                                                  ..createSync(recursive: true)
                                                  ..writeAsBytesSync(
                                                      fileBytes!);
                                                OpenFile.open(
                                                    '${path.path}/${months[DateTime.now().month - 1]}.xlsx');
                                              }
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No"))
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
