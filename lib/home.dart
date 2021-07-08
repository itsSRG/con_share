import 'dart:convert';
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
  // void initState(){
  //   super.initState();
  //   Firebase.initializeApp();
  // }
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference().child('groups');
    var groups = [];
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
                    setState(() {
                      
                    });
                  },
                ),
              ),
            ),
            FutureBuilder(
                future: ref.once(),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Admin: " + groups[index]["admin"].toString()),
                                Text("Group Name: " +
                                    groups[index]["group_name"].toString()),
                              ],
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
                .push(MaterialPageRoute(builder: (context) => AddGroup())).then((value) => setState((){}));
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