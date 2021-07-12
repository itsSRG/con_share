import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'constants.dart' as cnst;
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';

class SelectContacts extends StatefulWidget {
  final String? grpName;
  const SelectContacts({Key? key, this.grpName}) : super(key: key);
  _SelectContactsState createState() => _SelectContactsState();
}

class _SelectContactsState extends State<SelectContacts> {
  List<cnst.UserContactItem> _userList = [
    cnst.UserContactItem(
      contactName: "Fetching Names",
      number: "Fetching Mobile Numbers",
    )
  ];

  Future<void> requestAnswer() async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();

      contacts.forEach((contact) async {
        var mobilenum = contact.phones!.toList();

        if (mobilenum.length != 0) {
          var userContact = cnst.UserContactItem(
              contactName: contact.displayName ?? "No Name Available",
              number: mobilenum[0].value ?? "0");
          _userList.add(userContact);
        }
      });
      _userList.removeAt(0);

      if (cnst.selected![widget.grpName] == null) {
        cnst.selected![widget.grpName] =
            new List.filled(_userList.length, false);
        
      }
      if (cnst.final_val != null)
      {
        if (cnst.final_val[cnst.group_unique[widget.grpName]]![cnst.currentUser!.email] == null)
        {
          cnst.final_val[cnst.group_unique[widget.grpName]]![cnst.currentUser!.email] = [];
        }
        for (int i = 0; i <_userList.length; i++)
        {
          for (var j in cnst.final_val[cnst.group_unique[widget.grpName]]![cnst.currentUser!.email]!)
          {
            if (_userList[i].contactName == j.contactName && _userList[i].number == j.number)
            {
              print('select changed');
              cnst.selected![widget.grpName]![i] = true;
            }
          }
          
        }
      }
    }
  }

  Widget theList() {
    if (cnst.selected![widget.grpName] == null) {
      return Center(
          child: Column(children: [
        Container(
            margin: EdgeInsets.all(20),
            child: Text(
                'Contacts Permission Is Required To Use The App, If Done Please Wait, If Not Please Enable From Settings !')),
        CircularProgressIndicator()
      ]));
    } else {
      return ListView.builder(
        itemCount: _userList.length,
        shrinkWrap: true,
        itemBuilder: (context, contactIndex) {
          return CheckboxListTile(
            value: (cnst.selected![widget.grpName]![contactIndex]),
            onChanged: (bool? check) {
              print('Atleast check box click detected');
              setState(() {
                cnst.selected![widget.grpName]![contactIndex] =
                    !cnst.selected![widget.grpName]![contactIndex];

                if (cnst.selected![widget.grpName]![contactIndex] == true) {
                  print('is there a problem here ?');
                  print(cnst.final_val[cnst.group_unique[widget.grpName]]![cnst.currentUser!.email]!);
                  cnst.final_val[cnst.group_unique[widget.grpName]]![cnst.currentUser!.email]!
                      .add(_userList[contactIndex]);
                } else {
                  cnst.final_val[widget.grpName]!
                      .remove(_userList[contactIndex]);
                }

                print("--------------------------");
                for (var i in cnst
                    .final_val[cnst.group_unique[widget.grpName]]![cnst.currentUser!.email]!) {
                  print(i.contactName);
                }
                print("--------------------------");
              });
            },
            title: Text(_userList[contactIndex].contactName),
            subtitle: Text(_userList[contactIndex].number),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    requestAnswer().then((result) {
      setState(() {
        print("Hello");
      });
    });
  }

  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final ref = fb
        .reference()
        .child('groups')
        .child(cnst.group_unique[widget.grpName].toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  print('Group Unique Id');
                  print(cnst.group_unique[widget.grpName]);
                  print('Group Unique Id');
                  ref.child('contacts').child(cnst.currentUser!.id).remove();
                  for (var i in cnst
                      .final_val[cnst.group_unique[widget.grpName]]![cnst.currentUser!.email]!) {
                    ref
                        .child('contacts')
                        .child(cnst.currentUser!.id)
                        .push()
                        .set({'${i.contactName}': '${i.number}'});
                  }
                  cnst.initialize();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Add selected",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(child: theList())
        ],
      ),
    );
  }
}
