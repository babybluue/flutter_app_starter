import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/material.dart';

class PeripheralView extends StatefulWidget {
  const PeripheralView({super.key});
  @override
  State<PeripheralView> createState() => _PeripheralViewState();
}

class _PeripheralViewState extends State<PeripheralView> {
  bool _advertising = false;
  final PeripheralManager _manager = PeripheralManager();

  Future<void> startAdvertising() async {
    if (_advertising) {
      return;
    }

    await _manager.removeAllServices();

    final advertisement =
        Advertisement(name: 'flutter-app', manufacturerSpecificData: [
      ManufacturerSpecificData(
          id: 0x1d9e2, data: Uint8List.fromList([0x01, 0x02, 0x03]))
    ], serviceUUIDs: [
      UUID.fromString('1234567890abcdef')
    ], serviceData: {
      UUID.fromString('1234567890abcdef'):
          Uint8List.fromList([0x01, 0x02, 0x03])
    });

    await _manager.startAdvertising(advertisement);
    _advertising = true;
  }

  Future<void> stopAdvertising() async {
    if (!_advertising) {
      return;
    }
    await _manager.stopAdvertising();
    _advertising = false;
  }

  @override
  void initState() {
    super.initState();

    _advertising = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextButton(
              onPressed: () => startAdvertising(),
              child: const Text('Check Bluetooth')),
          TextButton(
              onPressed: () => stopAdvertising(),
              child: const Text('Start Scanning')),
        ],
      ),
    );
  }
}
