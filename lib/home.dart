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
    return Container(
      child: ElevatedButton(
        child: Text("Click"),
        onPressed: () {
          ref.child(grpname).set(cnst.final_val[0].contactName);
        },
      ),
    );
  }
}
