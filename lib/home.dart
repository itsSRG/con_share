import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'constants.dart' as cnst;

class HomeReal extends StatefulWidget {
  const HomeReal({Key? key}) : super(key: key);

  @override
  _HomeRealState createState() => _HomeRealState();
}

class _HomeRealState extends State<HomeReal> {
  final fb = FirebaseDatabase.instance;
  final grpname = "Family";
  @override
  // void initState(){
  //   super.initState();
  //   Firebase.initializeApp();
  // }
  Widget build(BuildContext context) {
    final ref = fb.reference();
    var groups;
    ref.once().then((value) => groups = value.value);

    Future<Map<String, dynamic>> output  = json.decode(groups).cast<Map<String, dynamic>>();
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
                    ref.once().then((value) => groups = value.value);
                  },
                ),
              ),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('You Have an error! ${snapshot.error.toString()}');
                } 
                else if (snapshot.hasData) {
                  print(groups.runtimeType);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: output,
            )
          ],
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