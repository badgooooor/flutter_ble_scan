import 'package:flutter/material.dart';

class DeviceResult {
  final String name;
  final String localeName;
  final int rssi;
  final String macAddress;
  const DeviceResult(this.name, this.localeName, this.rssi, this.macAddress);

  Widget createCard() {
    return new Card(
        child: Column(
      children: <Widget>[
        ListTile(
          leading: Text(this.rssi.toString()),
          title: Text('${this.name} (${this.localeName})'),
          subtitle: Text('${this.macAddress}'),
        ),
      ],
    ));
  }
}
