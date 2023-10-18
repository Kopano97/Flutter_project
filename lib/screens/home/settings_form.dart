import 'package:flutter/material.dart';
import 'package:kopbrewcrew/models/user.dart';
import 'package:kopbrewcrew/services/database.dart';
import 'package:kopbrewcrew/shared/canstants.dart';
import 'package:kopbrewcrew/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {


  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  late  String? _currentName = null;
  late String? _currentSugars = null;
  late int? _currentStrength = null;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData? userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData?.name,
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20.0),
                //drop down
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? userData!.sugars,
                  items: sugars.map((sugar){
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  //validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentSugars = val!),
                ),
                SizedBox(height: 20.0),
                //slider
                Slider(
                  value: (_currentStrength ?? userData?.strength)!.toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? userData!.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? userData!.strength],
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStrength = val.round()),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? userData!.sugars,
                          _currentName ?? userData!.name,
                          _currentStrength ?? userData!.strength,
                          Duration(seconds: 5));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[400]
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else{
              return Loading();
        }
      }
    );
  }
}

