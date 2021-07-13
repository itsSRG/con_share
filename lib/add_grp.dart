import 'dart:ui';

import 'package:con_share/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'constants.dart' as cnst;

class AddGroup extends StatelessWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference().child('groups').push();
    final myController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Group'),
      ),
      body: Column(
        children: [
          Center(
            child: TextField(
              textAlign: TextAlign.center,
              controller: myController,
              decoration: InputDecoration(hintText: 'Enter Group Name'),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () {
              ref.set({'group_name': myController.text});
              
              ref.child('users').push().set({'${currentUser!.id}' : '${currentUser!.email}'}).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully Added')));
              }).catchError((onError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(onError)));
              });
              cnst.initialize();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
