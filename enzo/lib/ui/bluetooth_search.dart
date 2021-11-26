import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:enzo/utils/shared_pref.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scientisst_sense/scientisst_sense.dart';

class BluetoothSearch extends StatefulWidget {
  const BluetoothSearch(this.onAdd, {Key? key}) : super(key: key);
  final Function onAdd;

  @override
  _BluetoothSearchState createState() => _BluetoothSearchState();
}

class _BluetoothSearchState extends State<BluetoothSearch> {
  StreamSubscription? _subscription;
  Map<String, BluetoothDiscoveryResult> devices = {};

  @override
  void dispose() {
    _subscription?.cancel();
    FlutterBluetoothSerial.instance.cancelDiscovery();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkBluetooth().then((value) => _checkLocation());
  }

  Future<bool?> showBluetoothDialog() async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Turn on Bluetooth'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('You need to turn on Bluetooth on your device.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              //await AppSettings.openBluetoothSettings();
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
    return result;
  }

  Future<bool> _checkBluetooth() async {
    if (!(await FlutterBluetoothSerial.instance.isEnabled ?? false)) {
      if (Platform.isAndroid) {
        // Request to turn on Bluetooth within an app
        BluetoothEnable.enableBluetooth.then((result) {
          return result == "true";
        });
      } else {
        return false;
      }
    }
    return true;
  }

  Future<bool> _checkLocation() async {
    final location = Location();
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return false;
      }
    }
    return true;
  }

  /*Future<void> _searchDevices() async {
    final bluetoothEnabled = await _checkBluetooth();
    final locationEnabled = await _checkLocation();
    if (!bluetoothEnabled || !locationEnabled) {
      debugPrint("Something went wrong");
      // TODO: show error dialog
      return;
    }

    _subscription = FlutterBluetoothSerial.instance.startDiscovery().listen(
      (result) {
        if (result.device.name?.toLowerCase().contains(widget.type) ?? false) {
          final address = result.device.address;
          if (_devices.isEmpty) {
            _devicesOrder.add(address);
          } else {
            for (int i = 0; i < _devices.length; i++) {
              if (!_devicesOrder.contains(address) &&
                  _devices[_devices.keys.elementAt(i)]!.rssi < result.rssi) {
                _devicesOrder.insert(i, address);
                break;
              }
            }
          }
          _devices[address] = result;
          if (mounted) {
            setState(() {});
          }
        }
      },
    );
    Future.delayed(const Duration(seconds: 5)).then((_) {
      _searching = false;
      _subscription?.cancel();
      FlutterBluetoothSerial.instance.cancelDiscovery();
      if (mounted) {
        setState(() {});
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Procurando dispositivos",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 32),
                      SpinKitWave(
                        color: Theme.of(context).colorScheme.secondary,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FlutterBluetoothSerial.instance.startDiscovery(),
                    builder: (context,
                        AsyncSnapshot<BluetoothDiscoveryResult> snap) {
                      if (snap.hasData) {
                        final device = snap.data;
                        final address = device!.device.address;
                        final name = device.device.name ?? "";
                        if (!devices.containsKey(address) &&
                            (name.toLowerCase().contains("e-covig") ||
                                name.toLowerCase().contains("scientisst"))) {
                          devices[address] = device;
                        }
                      }
                      if (devices.isEmpty) return const _EmptyDevices();
                      return ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          final device = devices.entries.elementAt(index).value;
                          return ListTile(
                              leading: const Icon(Icons.arrow_right),
                              title: Text(device.device.name!),
                              subtitle: Text(device.device.address),
                              onTap: () {
                                final type = device.device.name!
                                        .toLowerCase()
                                        .contains("e-covig")
                                    ? "ecovig"
                                    : "scientisst";
                                print(type);
                                _addDevice(type, device.device.address);
                              });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addDevice(String type, String address) async {
    final paired =
        (await FlutterBluetoothSerial.instance.getBondStateForAddress(address))
                .isBonded ||
            ((await FlutterBluetoothSerial.instance
                    .bondDeviceAtAddress(address, passkeyConfirm: true)
                    .timeout(
                      const Duration(seconds: 10),
                      onTimeout: () => false,
                    )) ??
                false);

    if (paired) {
      await SharedPref.save(type, address);
      widget.onAdd();
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}

class _EmptyDevices extends StatelessWidget {
  const _EmptyDevices({this.text = "", Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: const Icon(Icons.warning, size: 52),
          ),
          const SizedBox(height: 16),
          const Text(
            "Nenhum dispositivo encontrado.",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
