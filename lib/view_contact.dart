import 'package:flutter/material.dart';

class ContactView extends StatefulWidget {
  final contacts;
  final user;
  const ContactView({Key? key, this.contacts, this.user}) : super(key: key);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(title: Text('Contacts'),),
      body: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.contacts!.length,
              itemBuilder: (BuildContext context, int count) {
                if(widget.contacts!.length == 0)
                {
                  return Text('No Contacts Shared By This User !');
                }
                return Column(
                  children: [
                    Text("Contact Name" + widget.contacts![count].toString()),
                    Text("Contact Name" + widget.contacts![count].toString())
                  ],
                );
              })),
    );
  }
}
