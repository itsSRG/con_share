import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'constants.dart' as cnst;
import 'home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<cnst.UserContactItem> _userList = [
    cnst.UserContactItem(
      contactName: "Fetching Names",
      number: "Fetching Mobile Numbers",
    )
  ];

  Future<void> requestAnswer() async {
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

    if (cnst.selected == null)
      cnst.selected = new List.filled(_userList.length, false);
  }

  Widget theList() {
    if (cnst.selected == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: _userList.length,
        shrinkWrap: true,
        itemBuilder: (context, contactIndex) {
          return CheckboxListTile(
            value: (cnst.selected![contactIndex]),
            onChanged: (bool? check) {
              setState(() {
                cnst.selected![contactIndex] = !cnst.selected![contactIndex];

                if (cnst.selected![contactIndex] == true) {
                  cnst.final_val.add(_userList[contactIndex]);
                } else {
                  cnst.final_val.remove(_userList[contactIndex]);
                }

                print("--------------------------");
                for (var i in cnst.final_val) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeReal()));
                },
                child: Text(
                  "Add Selected",
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
