import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/screens/trips_history_screen.dart';
import '../screens/splashscreen/splash_screen.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key, this.name, this.email}) : super(key: key);
  String? name;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer Header
          Container(
            height: 165,
            color: Colors.grey,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        email.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripsHistoryScreen(),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.white54,
              ),
              title: Text(
                "History",
                style: TextStyle(color: Colors.white54),
              ),
              // onTap: () {},
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white54,
              ),
              title: Text(
                "My Profile",
                style: TextStyle(color: Colors.white54),
              ),
              // onTap: () {},
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white54,
              ),
              title: Text(
                "About",
                style: TextStyle(color: Colors.white54),
              ),
              // onTap: () {},
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MySplashScreen(),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white54,
              ),
              title: Text(
                "Signout",
                style: TextStyle(color: Colors.white54),
              ),
              // onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
