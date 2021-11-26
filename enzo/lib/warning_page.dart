import 'package:enzo/metrics_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WarningPage extends StatefulWidget {
  const WarningPage({Key? key}) : super(key: key);

  @override
  _WarningPageState createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(
        msg: "Nao deve fazer desporto!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0);
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.of(context).pop();
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
                          Icons.warning,
                          size: 150,
                        ))),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red, shape: const CircleBorder()),
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
