import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerProvider extends ChangeNotifier {
  Barcode? _result;
  QRViewController? _controller;
  int? _teacherid;
  final List<String> _absentees = [];
  final List<String> _namesOfStudent = [];
  final List<String> _timeOfScan = [];
  final List<String> _students = [];
  int? _numberOfStudents;
  String _user = "";

  Barcode? get result => _result;
  QRViewController? get controller => _controller;
  int? get teacherid => _teacherid;
  List<String> get absentees => _absentees;
  List<String> get namesOfStudent => _namesOfStudent;
  List<String> get timeOfScan => _timeOfScan;
  int? get numberOfStudents => _numberOfStudents;
  List<String> get students => _students;
  String get user => _user;

  void setData(Barcode result) {
    _result = result;
  }

  void setTeacherId(int teacherId) {
    _teacherid = teacherId;
  }

  void setAbsentees() async {
    ConnectionSettings c = ConnectionSettings(
        host: 'sql6.freemysqlhosting.net',
        user: 'sql6588996',
        db: 'sql6588996',
        password: 'S9DPyTQx87');
    MySqlConnection db = await MySqlConnection.connect(c);
    Results result = await db.query(
        "SELECT student_fullname FROM flutter_students_tbl WHERE teacher_id = ${teacherid!}");
    for (var row in result) {
      _absentees.add(row[0]);
      _students.add(row[0]);
    }
    _numberOfStudents = _absentees.length;
    db.close();
    notifyListeners();
  }

  void editTime(String edited, int index) {
    _timeOfScan[index] = edited;
    notifyListeners();
  }

  void setUser(String userString) {
    _user = userString;
  }

  void reset() {
    _absentees.clear();
    _namesOfStudent.clear();
    _timeOfScan.clear();
    _students.clear();
  }

  void delete(int index) {
    _absentees.add(_namesOfStudent[index]);
    _namesOfStudent.removeAt(index);
    notifyListeners();
  }
}
