import 'package:flutter/material.dart';
import 'package:kopbrewcrew/models/user.dart';
import 'package:kopbrewcrew/screens/authenticate/authenticate.dart';
import 'package:kopbrewcrew/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {


    final user = Provider.of<MyUser?>(context);
    print(user);
    //return home or auth widget
    if(user == null){
      return Authenticate();
    }else{
      return Home();
    }
    }
}
