import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  late final StreamSubscription _stateChangedSubscription;
  late final StreamSubscription _discoveredSubscription;
  final PeripheralManager _peripheralManager = PeripheralManager();
  final CentralManager _manager = CentralManager();
  final List<DiscoveredEventArgs> _discoveries = [];
  bool _discovering = false;

  void checkBluetooth() async {
    _stateChangedSubscription = _manager.stateChanged.listen((event) async {
      if (event.state == BluetoothLowEnergyState.unauthorized &&
          Platform.isAndroid) {
        await _manager.authorize();
      }
    });

    // _peripheralManager
    //     .startAdvertising(Advertisement(name: 'flutter-test', serviceData: {
    //   Guid('0000180D-0000-1000-8000-00805F9B34FB'): [0x01, 0x02, 0x03]
    // }));

    _discoveredSubscription = _manager.discovered.listen((event) async {
      final peripheral = event.peripheral;

      final index = _discoveries.indexWhere((i) => i.peripheral == peripheral);
      if (index < 0) {
        _discoveries.add(event);
      } else {
        _discoveries[index] = event;
      }
      setState(() {});
    });
  }

  Future<void> startDiscovery() async {
    if (_discovering) {
      return;
    }
    _discoveries.clear();
    await _manager.startDiscovery();
    _discovering = true;
  }

  Future<void> stopDiscovery() async {
    if (!_discovering) {
      return;
    }
    await _manager.stopDiscovery();
    _discovering = false;

    setState(() {
      _discoveries.clear();
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
      serviceUuids: [Guid('0000180D-0000-1000-8000-00805F9B34FB')],
      txPowerLevel: null,
      appearance: null,
    );
  }

  @override
  void initState() {
    super.initState();
    checkBluetooth();
  }

  @override
  void dispose() {
    _stateChangedSubscription.cancel();
    _discoveredSubscription.cancel();
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
              onPressed: () => startDiscovery(),
              child: const Text('Start Scanning')),
          TextButton(
              onPressed: () => stopDiscovery(), child: const Text('Clear')),
          Expanded(
              child: ListView(
            children: [
              for (final discovery in _discoveries)
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
                            discovery.rssi.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                            child: Text(
                                discovery.advertisement.manufacturerSpecificData
                                    .toString(),
                                overflow: TextOverflow.ellipsis)),
                        // SizedBox(
                        //     width: 120,
                        //     child: Text(
                        //         discovery.advertisement.name != null
                        //             ? discovery.advertisement.name.toString()
                        //             : '',
                        //         overflow: TextOverflow.ellipsis)),
                        // SizedBox(
                        //   width: 40,
                        //   child: Text(
                        //       discovery.advertisement.serviceUUIDs.toString(),
                        //       overflow: TextOverflow.ellipsis),
                        // ),
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
