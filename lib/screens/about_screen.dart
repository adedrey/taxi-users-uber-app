import 'package:flutter/material.dart';

import '../main.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          // Company Logo
          Container(
            height: 230,
            child: Center(
              child: Image.asset(
                "assets/img/carlogo.png",
                width: 240,
              ),
            ),
          ),

          Column(
            children: [
              // company name
              const Text(
                "Uber Clone",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ABout you and your company

              const Text(
                "This app has been developed by Emmanuel Adedire. "
                "Message me for your riders app software development",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Close
              // Close Button
              ElevatedButton(
                onPressed: () {
                  MyApp.restartApp(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white54,
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
