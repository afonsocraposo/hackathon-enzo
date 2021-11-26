import 'dart:async';

import 'package:enzo/home_page.dart';
import 'package:enzo/ui/chart.dart';
import 'package:enzo/utils/shared_pref.dart';
import 'package:enzo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scientisst_sense/scientisst_sense.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Workout extends StatefulWidget {
  const Workout({Key? key}) : super(key: key);

  @override
  _WorkoutState createState() => _WorkoutState();
}

const BUTTON_STRING = "💪";

class _WorkoutState extends State<Workout> {
  Duration _duration = Duration.zero;
  DateTime? _start;
  late Timer _timer;
  Sense? sense;
  GlobalKey _key = GlobalKey();
  final List<int?> y = [];
  final List<double?> listx = [];
  final List<double?> listy = [];
  final List<double?> listz = [];
  final List<DateTime> x = [];
  final List<int> bufferEcg = [];
  final List<double> bufferAx = [];
  final List<double> bufferAy = [];
  final List<double> bufferAz = [];
  StreamSubscription? subscription;
  int counter = 0;
  StreamSubscription? _accelSubscription;
  double ax = 0;
  double ay = 0;
  double az = 0;

  start() async {
    //final address = await SharedPref.read("scientisst");
    final address = "08:3A:F2:49:AC:BE";
    sense = Sense(address);
    bool connected = false;
    while (!connected) {
      try {
        await sense!.connect();
      } catch (e) {}
      connected = sense!.connected;
    }
    _start = DateTime.now();
    x.add(_start!);
    y.add(0);

    _accelSubscription = accelerometerEvents.listen((sensorEvent) {
      ax = sensorEvent.x;
      ay = sensorEvent.y;
      az = sensorEvent.z;
    });

    await sense!.start(100, [1]);
    subscription = sense!.stream(numFrames: 1).listen(addData);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = DateTime.now().difference(_start!);
      });
    });
  }

  void addData(List<Frame> frames) {
    final value = frames.first.a.first!;
    x.add(x.last.add(const Duration(milliseconds: 1000 ~/ 100)));
    y.add(value);
    bufferEcg.add(value);
    listx.add(ax);
    listy.add(ay);
    listz.add(az);
    bufferAx.add(ax);
    bufferAy.add(ay);
    bufferAz.add(az);
    counter++;
    final n = x.length - 100 * 5;
    if (n > 0) {
      x.removeRange(0, n);
      y.removeRange(0, n);
      listx.removeRange(0, n);
      listy.removeRange(0, n);
      listz.removeRange(0, n);
    }
    if (counter > 1000) {
      counter = 0;
      sendData(List.from(bufferEcg), List.from(bufferAx), List.from(bufferAy),
          List.from(bufferAz));
      bufferEcg.clear();
      bufferAx.clear();
      bufferAy.clear();
      bufferAz.clear();
    }
    setState(() {});
  }

  sendData(
      List<int> ecg, List<double> x, List<double> y, List<double> z) async {
    final String result = await sendECG(ecg, x, y, z);
    if (result.isNotEmpty) {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0);
    }
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  void dispose() {
    _timer.cancel();
    sense?.disconnect();
    _accelSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            SizedBox(
              height: 200,
              child: Chart(
                x,
                y,
              ),
            ),
            SizedBox(
              height: 100,
              child: Chart(
                x,
                listx,
              ),
            ),
            SizedBox(
              height: 100,
              child: Chart(
                x,
                listy,
              ),
            ),
            SizedBox(
              height: 100,
              child: Chart(
                x,
                listz,
              ),
            ),
            Expanded(child: Container()),
            Center(
              child: Text(
                _duration.toString().split('.').first.padLeft(8, "0"),
                style: const TextStyle(
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.error),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.warning,
                      size: 32,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64),
                      child: Dismissible(
                        confirmDismiss: (dismiss) async {
                          if (dismiss == DismissDirection.startToEnd) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "AJUDAAAAA!!!!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 20.0);
                            setState(() {
                              _key = GlobalKey();
                            });
                          }
                          return false;
                        },
                        key: _key,
                        child: RawMaterialButton(
                          shape: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              BUTTON_STRING,
                              style: TextStyle(
                                fontSize: 32,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          fillColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.flag_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
