import 'package:enzo/metrics_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 200, 50, 50),
              child: Container(
                child: const Text(
                  "Ola Enzo",
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(70.0),
                  child: ElevatedButton(
                    onPressed: () {  Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) => const Metrics()));
                    },
                    child: const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                            child: Text(
                          "Start",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ))),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green, shape: const CircleBorder()),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 60,
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
