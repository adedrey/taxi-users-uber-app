import 'package:flutter/material.dart';

class UserInfoDesignUIWidget extends StatefulWidget {
  String? textinfo;
  IconData? iconData;

  UserInfoDesignUIWidget({
    this.textinfo,
    this.iconData,
  });

  @override
  _UserInfoDesignUIWidgetState createState() => _UserInfoDesignUIWidgetState();
}

class _UserInfoDesignUIWidgetState extends State<UserInfoDesignUIWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.black,
        ),
        title: Text(
          widget.textinfo!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
