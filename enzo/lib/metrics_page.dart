import 'package:flutter/material.dart';

class Metrics extends StatefulWidget {
  const Metrics({Key? key}) : super(key: key);

  @override
  _MetricsState createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  String temperatura = "37º";
  String spo2 = "20";
  String bpm = "56";

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
                  temperatura,
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
                spo2 + "%",
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
                bpm,
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
