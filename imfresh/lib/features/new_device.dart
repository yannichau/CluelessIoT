import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class NewDevice extends StatefulWidget {
  const NewDevice({Key? key}) : super(key: key);

  @override
  _NewDeviceState createState() => _NewDeviceState();
}

class _NewDeviceState extends State<NewDevice> {
  bool textFound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: !textFound
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MobileScanner(
                      controller: MobileScannerController(
                          facing: CameraFacing.back, torchEnabled: true),
                      onDetect: (barcode, args) {
                        final String code = barcode.rawValue;
                        print('Barcode: $code');
                        setState(() {
                          textFound = true;
                        });
                      },
                    ),
                  )
                : const Text(
                    "Adding new device...",
                    style: TextStyle(fontSize: 20),
                  ),
          ),
        ),
      ),
    );
  }
}
