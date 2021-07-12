import 'package:flutter/material.dart';
import 'select_contacts.dart';
import 'constants.dart' as cnst;
import 'package:flutter/services.dart';

class ContactView extends StatefulWidget {
  final List<cnst.UserContactItem>? contacts;
  final String user_email;
  final String grpName;
  const ContactView(
      {Key? key,
      this.contacts,
      required this.user_email,
      required this.grpName})
      : super(key: key);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override

  Widget build(BuildContext context) {
    print('The current user is : ');
    print(widget.user_email);
    print(cnst.currentUser!.email);
    print('Time');
    if (widget.contacts == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Contacts'),
          ),
          body: Container(
            child: Text('No Contacts By This User'),
          ),
          floatingActionButton: new Visibility(
            visible:
                widget.user_email == cnst.currentUser!.email ? true : false,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                print('view contact grp_name is :');
                print(widget.grpName);
                print('view contact grp_name is :');
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) =>
                            SelectContacts(grpName: widget.grpName)))
                    .then((_) async {
                await cnst.initialize().then((value) => setState(() {}));
              });
              },
            ),
          ));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.contacts!.length,
                itemBuilder: (BuildContext context, int count) {
                  if (widget.contacts!.length == 0) {
                    return Container(
                        child: Align(
                      child: Text('No Contacts Shared By This User !'),
                      alignment: Alignment.center,
                    ));
                  }
                  return ListTile(
                    title: Text(widget.contacts![count].contactName),
                    subtitle: Text(widget.contacts![count].number),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.contacts![count].number));
                    },
                  );
                })),
        floatingActionButton: new Visibility(
          visible: widget.user_email == cnst.currentUser!.email ? true : false,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              print('view contact grp_name is :');
              print(widget.grpName);
              print('view contact grp_name is :');
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          SelectContacts(grpName: widget.grpName)))
                  .then((_) async {
                await cnst.initialize().then((value) => setState(() {}));
              });
            },
          ),
        ));
  }
}
