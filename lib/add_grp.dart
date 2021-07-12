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
              controller: myController,
              decoration: InputDecoration(hintText: 'Enter Group Name'),
            ),
          ),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () {
              print('I start here');
              group_unique[myController.text] = ref.key;
              print(ref.key);
              print(myController.text);
              print(group_unique[myController.text]);
              print('I end here');
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
