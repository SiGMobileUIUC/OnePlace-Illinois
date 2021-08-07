import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oneplace_illinois/src/misc/colors.dart';
import 'package:oneplace_illinois/src/providers/accountProvider.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';
import 'package:oneplace_illinois/src/widgets/boxItem.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  SettingsDrawer({Key? key}) : super(key: key);

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);
    final AccountProvider account =
        Provider.of<AccountProvider>(context, listen: false);
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey[200]
                : Colors.grey[900],
      ),
      child: Drawer(
        elevation: 5.0,
        child: ListView(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                user?.displayName ?? "",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              accountEmail: Text(
                user?.email ?? "",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Icon(
                    PlatformIcons(context).person,
                    size: 60.0,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryUofI,
              ),
            ),
            BoxItem(
              padding: 0.0,
              color: Colors.grey[800],
              child: Column(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    onTap: () async {
                      await account.signOut();
                      await _authService.signOut();
                    },
                    title: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
