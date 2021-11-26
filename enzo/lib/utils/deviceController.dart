import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

const MIN_TEMP = 25;
const MAX_TEMP = 45;

class DeviceController {
  final String address;
  BluetoothConnection? connection;
  Stream<DeviceData>? stream;
  bool? isConnecting;
  StreamSubscription? streamSubscription;
  bool isFingerMode = false;
  bool dummy;

  DeviceController(this.address, {this.dummy = false});

  Future<bool> connect() async {
    isConnecting = true;
    bool connected;
    if (!dummy) {
      connected =
          await BluetoothConnection.toAddress(address).then((connection) {
        if (connection != null) {
          this.connection = connection;
          stream = connection.input!
              .map((Uint8List data) => DeviceData.fromBytes(data))
              .asBroadcastStream();
          return true;
        } else {
          return false;
        }
      }).catchError((onError) {
        return false;
      });
    } else {
      await Future.delayed(Duration(seconds: 1));
      connected = true;
      final int fs = 1;
      final DummyDevice dummyDevice = DummyDevice(fs: fs);
      stream = Stream.periodic(
        Duration(milliseconds: 1000 ~/ fs),
        (int index) {
          dummyDevice.updateData(index);
          return DeviceData.fromBytes(
            utf8.encode(
              dummyDevice.getData(),
            ) as Uint8List,
          );
        },
      ).take(30 * fs).asBroadcastStream();
    }
    isConnecting = false;
    return connected;
  }

  bool isConnected() {
    if (!this.dummy) {
      return connection?.isConnected ?? false;
    } else {
      return true;
    }
  }

  void changeMode() => isFingerMode = !isFingerMode;

  void listen(Function(DeviceData data) onData,
      {Function? onConnectionLost, Function(Object error)? onError}) {
    if (connection != null || dummy) {
      streamSubscription?.cancel();
      streamSubscription = stream!.listen(onData, onDone: () {
        dispose();
        onConnectionLost!();
      }, onError: onError);
    } else {
      throw Exception("The device must be connected");
    }
  }

  void reset() {
    connection!.output.add(utf8.encode("0") as Uint8List);
  }

  void dispose() {
    streamSubscription?.cancel();
    connection?.dispose();
    connection = null;
    stream = null;
    streamSubscription = null;
  }
}

class DeviceData {
  double? temperature;
  int? heartRate;
  int? saturation;
  int? status;
  int? confidence;

  DeviceData.fromBytes(Uint8List data) {
    String string = utf8.decode(data).trim();
    RegExp re = RegExp(r'{.*}');
    Match? match = re.firstMatch(string);
    String jsonString =
        "{" + match!.group(0)!.replaceAll("{", "").replaceAll("}", "") + "}";
    //debugPrint(jsonString);
    Map<String, dynamic> values =
        Map<String, dynamic>.from(json.decode(jsonString));
    confidence = values["Confidence"];
    status = values["Status"];
    heartRate = values["HR"];
    saturation = values["SpO2"];
    temperature = values["Object Temperature"];
  }

  bool isFingerPlaced() {
    return status == 3;
  }

  bool isConfident() {
    return confidence! >= 70;
  }

  bool isTempPlaced() {
    return temperature! >= MIN_TEMP && temperature! <= MAX_TEMP;
  }
}

class DummyDevice {
  double temperature = 0;
  int heartRate = 0;
  int saturation = 0;
  int status = 0;
  int confidence = 0;
  int fs;

  DummyDevice({this.fs = 2});

  updateData(int index) {
    temperature = ((35 + (1 * fs) / (index + 1)) * 10).round() / 10;
    heartRate = 64 + (6 * fs) ~/ (index + 1);
    if (index > 10 * fs) {
      saturation = 95 + (6 * fs) ~/ (index + 1);
      status = (3 - (3 * fs) / (index + 1)).clamp(0, 3).round();
      confidence = 71 - (3 * fs) ~/ (index + 1);
    }
  }

  String getData() {
    return "{\"HR\": $heartRate, \"Confidence\": $confidence, \"SpO2\": $saturation, \"Status\": $status, \"Object Temperature\": $temperature, \"Ambient Temperature\": 15.0}";
  }
}
