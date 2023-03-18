import 'package:Attendify/providers/cameratabprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AbsentScreen extends StatelessWidget {
  const AbsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF416E8E),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg2.jpg'), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF416e8e).withOpacity(0.6),
            ),
            child: ListView.builder(
              itemCount: context.read<ScannerProvider>().absentees.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: const Color(0xFFCBF7ED),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: ListTile(
                      title: Text(
                        context.watch<ScannerProvider>().absentees[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
