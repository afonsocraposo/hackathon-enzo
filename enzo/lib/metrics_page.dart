import 'package:enzo/check_page.dart';
import 'package:enzo/utils/deviceController.dart';
import 'package:enzo/utils/shared_pref.dart';
import 'package:enzo/utils/utils.dart';
import 'package:enzo/warning_page.dart';
import 'package:flutter/material.dart';

class Metrics extends StatefulWidget {
  const Metrics({Key? key}) : super(key: key);

  @override
  _MetricsState createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  String temperatura = "--";
  String spo2 = "--";
  String bpm = "--";
  double maxTemp = -1;
  DeviceController? controller;

  @override
  void initState() {
    super.initState();
    initDevice();
  }

  initDevice() async {
    //final address = await SharedPref.read("ecovig");
    final address = "24:6F:28:1A:6B:92";
    controller = DeviceController(address);
    bool connected = false;
    while (!connected) {
      connected = await controller!.connect();
    }
    controller!.listen((data) {
      final temperature = data.temperature!;
      if (temperature > maxTemp) {
        maxTemp = temperature;
      }
      setState(() {
        temperatura = "$maxTemp";
        spo2 = "${data.saturation}";
        bpm = "${data.heartRate}";
      });
      if (data.confidence! > 90 && data.saturation! > 0 && data.status! > 2) {
        controller!.dispose();
        submitData(temperatura, spo2, bpm, data.confidence!);
      }
    });
  }

  void submitData(
      String temperatura, String spo2, String bpm, int confidence) async {
    final result = await sendecovig(double.tryParse(temperatura) ?? -1,
        int.tryParse(spo2) ?? -1, int.tryParse(bpm) ?? -1, confidence);
    if (result) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CheckPage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WarningPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                child: Text(
                  temperatura + "ºC" + " 🌡️",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Temperatura",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                spo2 + "%" + " 💨",
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "SPO2",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                bpm + "  ♥",
                style: const TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Batimento Cardiaco",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
