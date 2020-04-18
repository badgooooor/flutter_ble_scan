import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:try_flutter_ble/deviceResult.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Discovery',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'BLE Discovery'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  static List<DeviceResult> scanResult = [];
  Timer bleScan;

  void scanDevices() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResult = [];
      });
      for (ScanResult r in results) {
        print(
            '${r.device.name} found! rssi: ${r.rssi} ${r.advertisementData.serviceUuids}');
        r.advertisementData.serviceUuids.forEach((uuid) => print(uuid));
        print('${r.advertisementData.serviceData}');
        print('${r.device.id}');
        if (r.device.type != BluetoothDeviceType.unknown) {
          scanResult.add(DeviceResult(r.device.name,
              r.advertisementData.localName, r.rssi, r.device.id.toString()));
        }
      }
    });
    print("Scanned device" + scanResult.length.toString());
    for (DeviceResult r in scanResult) {
      print('${r.name} found! rssi: ${r.rssi}');
    }
    flutterBlue.stopScan();
  }

  @override
  void initState() {
    super.initState();
    bleScan = Timer.periodic(Duration(seconds: 10), (Timer t) => scanDevices());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new ListView.builder(
          itemCount: scanResult.length,
          itemBuilder: (BuildContext context, int index) {
            final DeviceResult r = scanResult[index];
            return r.createCard();
          }),
    );
  }
}
