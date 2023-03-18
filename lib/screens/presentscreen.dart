import 'package:Attendify/providers/cameratabprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PresentScreen extends StatelessWidget {
  const PresentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF416E8E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg2.jpg"), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xCC22395C).withOpacity(0.5),
          ),
          child: ListView.builder(
            itemCount: context.watch<ScannerProvider>().namesOfStudent.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: const Color(0xFFCBF7ED),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: ListTile(
                    title: Text(
                      context.watch<ScannerProvider>().namesOfStudent[index],
                    ),
                    subtitle: Text(
                        "Time: ${context.watch<ScannerProvider>().timeOfScan[index]}"),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Remove"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<ScannerProvider>().delete(index);
                                  Navigator.pop(context);
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              )
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController();
                          controller.text =
                              context.read<ScannerProvider>().timeOfScan[index];
                          return AlertDialog(
                            title: const Text("Edit"),
                            content: Row(
                              children: [
                                const Expanded(
                                  child: Text("Time: "),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                  ),
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<ScannerProvider>()
                                        .editTime(controller.text, index);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Ok")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"))
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
