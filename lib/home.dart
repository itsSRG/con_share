import 'dart:convert';
import 'package:con_share/group_view.dart';

import 'add_grp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'constants.dart' as cnst;

class HomeReal extends StatefulWidget {
  const HomeReal({Key? key}) : super(key: key);

  @override
  _HomeRealState createState() => _HomeRealState();
}

class _HomeRealState extends State<HomeReal> {
  @override
  void initState() {
    super.initState();
    // cnst.initialize().then((value) => setState((){}));
  }
  Widget build(BuildContext context) {
    // final fb = FirebaseDatabase.instance;
    // final ref = fb.reference().child('groups');
    List<String> groups = [];
    List<String> groups_unique_string = [];
    // ref.once().then((value) => groups = value.value);

    // Future<Map<String, dynamic>> output  = json.decode(groups).cast<Map<String, dynamic>>();
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ElevatedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
            ),
            FutureBuilder(
                future: cnst.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('You Have an error! ${snapshot.error.toString()}');
                  } else if (snapshot.hasData) {
                    
                    Map<dynamic,dynamic>.from(cnst.group_unique).forEach((key, value) {
                      if (cnst.user_email[value]!.contains(cnst.currentUser!.email))
                      {
                        groups.add(key);
                      }
                    });
                    return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: groups.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Center(
                                child: Text(
                                    groups[index]),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => GorupView(grpName : groups[index].toString())));
                              },
                            ),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddGroup()))
                .then((value) => setState(() {}));
          },
        ),
      ),
    );
  }
}

// ElevatedButton(
//         child: Text("Click"),
//         onPressed: () {
//           for (int i = 0; i< cnst.final_val.length; i++)
//           {
//             ref.child(grpname).child('user').child('contact$i').set(cnst.final_val[i].contactName);
//             ref.child(grpname).child('user').child('contact$i').child(cnst.final_val[i].contactName).set(cnst.final_val[i].number);
//           }
          
//         },
//       ),