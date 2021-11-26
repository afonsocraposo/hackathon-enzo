import 'package:enzo/metrics_page.dart';
import 'package:enzo/workout.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(
        msg: "Esta tudo OK",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 20.0);
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Workout()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(70),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                            child: Icon(
                          Icons.check,
                          size: 150,
                        ))),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green, shape: const CircleBorder()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
