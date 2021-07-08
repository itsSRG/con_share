import 'package:con_share/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddGroup extends StatelessWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference().child('groups');
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
              ref.push().set({'group_name': myController.text,
              'admin': currentUser!.email.toString()}).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully Added')));
              }).catchError((onError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(onError)));
              });
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
