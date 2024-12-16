import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  late List<ScanResult> scanResult = [];

  void checkBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print('Bluetooth is not supported');
      return;
    }

    _adapterStateStateSubscription = FlutterBluePlus.adapterState
        .listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.on) {
        print('Bluetooth is on');
      } else {
        print('Bluetooth is off');
      }
    });
  }

  void scanDevices() async {
    var bluetoothScan = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        setState(() {
          if (!scanResult.contains(results.last)) {
            scanResult.add(results.last);
          }
        });
      }
    });

    FlutterBluePlus.cancelWhenScanComplete(bluetoothScan);
  }

  void startScan() async {
    FlutterBluePlus.startScan(
        // withServices: [Guid('180F')],
        // removeIfGone: Duration(seconds: 1),
        timeout: const Duration(seconds: 20));
    scanDevices();
  }

  void clearResult() {
    setState(() {
      scanResult = [];
    });
  }

  void startAdvertising() {
    final advertisementData = AdvertisementData(
        advName: 'test-flutter',
        connectable: true,
        manufacturerData: {
          1234: [0x01, 0x02, 0x03]
        },
        serviceData: {
          Guid('0000180D-0000-1000-8000-00805F9B34FB'): [0x01, 0x02, 0x03]
        },
        serviceUuids: [
          Guid('0000180D-0000-1000-8000-00805F9B34FB')
        ]);
  }

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    checkBluetooth();
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () => checkBluetooth(),
              child: const Text('Check Bluetooth')),
          TextButton(
              onPressed: () => startScan(),
              child: const Text('Start Scanning')),
          TextButton(
              onPressed: () => clearResult(), child: const Text('Clear')),
          Expanded(
              child: ListView(
            children: [
              for (final result in scanResult)
                GestureDetector(
                  onTap: () async {
                    //
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            result.rssi.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                            width: 120,
                            child: Text(result.device.remoteId.toString(),
                                overflow: TextOverflow.ellipsis)),
                        SizedBox(
                            width: 120,
                            child: Text(result.device.advName,
                                overflow: TextOverflow.ellipsis)),
                        SizedBox(
                            width: 40,
                            child: Text(result.device.isConnected.toString(),
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                ),
            ],
          ))
        ],
      ),
    );
  }
}
