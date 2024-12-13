import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  void checkBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print('Bluetooth is not supported');
      return;
    }

    var bluetoothState =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print('state');
      if (state == BluetoothAdapterState.on) {
        print('Bluetooth is on');
      } else {
        print('Bluetooth is off');
      }
    });

    bluetoothState.cancel();
  }

  void scanDevices() async {
    var bluetoothScan = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        ScanResult r = results.last;
        print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
      }
    });

    FlutterBluePlus.cancelWhenScanComplete(bluetoothScan);
  }

  void startScan() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
  }

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.setLogLevel(LogLevel.verbose);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () => checkBluetooth(),
              child: const Text('Check Bluetooth')),
          TextButton(
              onPressed: () => startScan(),
              child: const Text('Start Scanning')),
          TextButton(
              onPressed: () => scanDevices(),
              child: const Text('Scan Devices')),
          Container()
        ],
      ),
    );
  }
}
