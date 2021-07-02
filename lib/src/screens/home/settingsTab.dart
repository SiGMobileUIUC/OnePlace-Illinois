import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';
import 'package:oneplace_illinois/src/widgets/boxItem.dart';

/*
Main page for the Add Item tab, will add more details later.
*/

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  ScrollController scrollController = ScrollController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return BoxItem(
      padding: 0.0,
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            onTap: () async {
              await _authService.signOut();
            },
            title: Text(
              'Log Out',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
