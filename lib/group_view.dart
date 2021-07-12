import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'constants.dart';
import 'view_contact.dart';
import 'select_contacts.dart' as selectContacts;

class GorupView extends StatefulWidget {
  final String? grpName;
  const GorupView({Key? key, this.grpName}) : super(key: key);

  @override
  _GorupViewState createState() => _GorupViewState();
}

class _GorupViewState extends State<GorupView> {
  var groups = [];

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference().child('groups');
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.grpName.toString()),
        ),
        body: FutureBuilder(
            future:
                ref.orderByChild('group_name').equalTo(widget.grpName).once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasError) {
                print('You Have an error! ${snapshot.error.toString()}');
              } else if (snapshot.hasData) {
                groups.clear();
                Map<dynamic, dynamic> values = snapshot.data!.value;
                values.forEach((key, values) {
                  groups.add(values);
                });
                var users_id = [];
                var user_email = [];
                var contacts = [];
                if (groups[0]['contacts'] != null) {
                  Map<String, dynamic>.from(groups[0]['contacts'])
                      .forEach((key, value) {
                    Map<String, dynamic>.from(value).forEach((key, value) {
                      contacts.add(value);
                    });
                  });
                }
                Map<String, dynamic>.from(groups[0]['users'])
                    .forEach((key, value) {
                  Map<String, dynamic>.from(value).forEach((key, value) {
                    users_id.add(key);
                    user_email.add(value);
                  });
                });
                print('Contacts:');
                print(contacts);
                print('User_Ids:');
                print(users_id);
                print('User Emails');
                print(user_email);
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: groups.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactView(
                                  contacts: contacts, user: users_id[index])));
                        },
                        title: Center(
                          child: Text("Name: " + user_email[index].toString()),
                        ),
                      ));
                    });
              }
              return CircularProgressIndicator();
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        selectContacts.SelectContacts(grpName: widget.grpName)))
                .then((value) => setState(() {}));
          },
        ));
  }
}

                          // Text("Contact: " +
                          //     groups[index][groups[index]
                          //             .keys
                          //             .toString()
                          //             .substring(
                          //                 1,
                          //                 groups[index].keys.toString().length -
                          //                     1)]
                          //         .toString()),