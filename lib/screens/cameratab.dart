import 'dart:io';

import 'package:attendancetracker_flutter2/providers/cameratabprovider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class ScannerTab extends StatefulWidget {
  const ScannerTab({super.key});

  @override
  State<ScannerTab> createState() => _ScannerTabState();
}

class _ScannerTabState extends State<ScannerTab> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            cutOutSize: 300,
            borderColor: Colors.blue,
            borderWidth: 10,
            borderRadius: 10),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(
      (data) {
        setState(
          () {
            context.read<ScannerProvider>().setData(data);
            if (data.code!.split(':')[2] == 'SECRET_KEY') {
              if (context.read<ScannerProvider>().teacherid.toString() ==
                  data.code!.split(':')[1]) {
                if (context
                    .read<ScannerProvider>()
                    .namesOfStudent
                    .contains(data.code!.split(':')[0])) {
                  return;
                }
                String minute = DateTime.now().minute < 10
                    ? "0${DateTime.now().minute}"
                    : DateTime.now().minute.toString();
                context
                    .read<ScannerProvider>()
                    .namesOfStudent
                    .add(data.code!.split(':')[0]);
                context
                    .read<ScannerProvider>()
                    .timeOfScan
                    .add("${DateTime.now().hour}:$minute");
                context
                    .read<ScannerProvider>()
                    .absentees
                    .remove(data.code!.split(':')[0]);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Scanned Successfully"),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
