import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class GorupView extends StatefulWidget {
  const GorupView({Key? key}) : super(key: key);

  @override
  _GorupViewState createState() => _GorupViewState();
}

class _GorupViewState extends State<GorupView> {
  var groups = [];

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference().child('Family').child('user');
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
      ),
      body: FutureBuilder(
          future: ref.once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasError) {
              print('You Have an error! ${snapshot.error.toString()}');
            } 
            else if (snapshot.hasData) {
        Map<dynamic, dynamic> values = snapshot.data!.value;
        values.forEach((key, values) {
            groups.add(values as Map);
        });
        return new ListView.builder(
            shrinkWrap: true,
            itemCount: groups.length,
            itemBuilder: (BuildContext context, int index) {
                return Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text("Name: " + groups[index].keys.toString()),
                    Text("Contact: "+ groups[index][groups[index].keys.toString().substring(1,groups[index].keys.toString().length - 1)].toString()),
                    ],
                ),
                );
            });
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
