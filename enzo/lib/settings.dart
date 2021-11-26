import 'package:enzo/ui/bluetooth_search.dart';
import 'package:enzo/ui/circular_process.dart';
import 'package:enzo/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Definições",
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (searching) {
                setState(() {
                  searching = false;
                });
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: SharedPref.read("ecovig"),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.hasData) {
                          return CircularButton(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Dispositivo COVID-19",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  (snap.data as String),
                                ),
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                searching = !searching;
                              });
                            },
                          );
                        } else {
                          return CircularButton(
                            color: Theme.of(context).disabledColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Dispositivo COVID-19",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Adicione um dispositivo",
                                ),
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                searching = !searching;
                              });
                            },
                          );
                        }
                      }
                      return const CircularButton(
                        child: CircularProgress(),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: SharedPref.read("scientisst"),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.hasData) {
                          return CircularButton(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Dispositivo ECG",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  (snap.data as String),
                                ),
                              ],
                            ),
                            onPressed: () {
                              //AddDevice();
                              setState(() {
                                searching = !searching;
                              });
                            },
                          );
                        } else {
                          return CircularButton(
                            color: Theme.of(context).disabledColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Dispositivo ECG",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Adicione um dispositivo",
                                ),
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                searching = !searching;
                              });
                            },
                          );
                        }
                      }
                      return const CircularButton(
                        child: CircularProgress(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              width: double.infinity,
              height: searching ? MediaQuery.of(context).size.height / 2 : 0,
              child: Column(
                children: [
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BluetoothSearch(() {
                      setState(() {
                        searching = false;
                      });
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  const CircularButton({
    this.color,
    this.child,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final Color? color;
  final Widget? child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(64),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color ?? Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: child ??
                  const SizedBox(
                    width: 32,
                    height: 32,
                  ),
            ),
          ),
          onPressed: onPressed ?? () {},
        ),
      ),
    );
  }
}
