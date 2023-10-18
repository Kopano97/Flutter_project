import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/brew.dart';
import 'brew_tile.dart';
import 'package:kopbrewcrew/shared/loading.dart';

class BrewList extends StatefulWidget {
  const BrewList({super.key});

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {


    final brews = Provider.of<List<Brew>?>(context); // Note the nullable type

    if(brews != null){
    return ListView.builder(
      itemCount: brews?.length,
      itemBuilder: (context, index) {
        return BrewTile(brew: brews![index]);
      },
    );
    }
    else{
      return Loading();
    }
  }
}
