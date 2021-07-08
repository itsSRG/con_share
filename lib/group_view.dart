import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

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
        title: Text("Groups"),
      ),
      body: FutureBuilder(
          future: ref.orderByChild('group_name').equalTo(widget.grpName).once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasError) {
              print('You Have an error! ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              groups.clear();
              Map<dynamic, dynamic> values = snapshot.data!.value;
              values.forEach((key, values) {
                groups.add(values as Map);
              });
              return new ListView.builder(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                            title: Center(
                      child: Column(
                        children: [
                          Text("Name: " + groups[index]['admin'].toString()),
                        ],
                      ),
                    )));
                  });
            }
            return CircularProgressIndicator();
          }),
    );
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