
import 'package:flutter/material.dart';
import 'package:kopbrewcrew/screens/home/settings_form.dart';
import 'package:kopbrewcrew/services/auth.dart';
import 'package:kopbrewcrew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:kopbrewcrew/screens/home/brew_list.dart';

import '../../models/brew.dart';



class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService(uid: '').brews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Kop Brew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Logout'),
            ),
            TextButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: ()=> _showSettingsPanel(),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover
            ),
          ),
            child: BrewList()
        ),
      ),
    );
  }
}
