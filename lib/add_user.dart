import 'dart:ui';
import 'package:con_share/constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddUser extends StatelessWidget {
  final String? grpName;
  const AddUser({Key? key, required this.grpName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference().child('groups').child(cnst.group_unique[grpName]!);
    final myController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Column(
        children: [
          Center(
            child: TextField(
              controller: myController,
              decoration: InputDecoration(hintText: 'Enter User Gmail id'),
            ),
          ),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () {
              print('I start here');
              print(ref.key);
              print(myController.text);
              print(cnst.group_unique[myController.text]);
              print('I end here');

              ref.child('users').push().set({'none': '${myController.text}'});
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
