import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/main.dart';
import 'package:users_app/widgets/user_info_design_ui.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // name
            Text(
              userModelCurrentInfo!.name!,
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 38,
            ),

            // Phone
            UserInfoDesignUIWidget(
              textinfo: userModelCurrentInfo!.phone,
              iconData: Icons.phone_iphone,
            ),

            // Email
            UserInfoDesignUIWidget(
              textinfo: userModelCurrentInfo!.email,
              iconData: Icons.phone_iphone,
            ),
            const SizedBox(
              height: 20,
            ),
            // Close Button
            ElevatedButton(
              onPressed: () {
                MyApp.restartApp(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlueAccent,
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
      ),
    );
  }
}
