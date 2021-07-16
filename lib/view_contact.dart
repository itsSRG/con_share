import 'package:flutter/material.dart';
import 'select_contacts.dart';
import 'constants.dart' as cnst;
import 'package:flutter/services.dart';

class ContactView extends StatefulWidget {
  final String user_email;
  final String grpName;
  const ContactView({Key? key, required this.user_email, required this.grpName})
      : super(key: key);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    if (cnst.final_val[cnst.group_unique[widget.grpName]]![widget.user_email] ==
        null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Contacts'),
          ),
          body: Column(children: [
            ElevatedButton(
              child: Icon(Icons.refresh),
              onPressed: () async {
                await cnst.initialize().then((value) => setState(() {}));
              },
            ),
            SizedBox(
              height: 200,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('No Contacts By This User')),
            ),
          ]),
          floatingActionButton: new Visibility(
            visible:
                widget.user_email == cnst.currentUser!.email ? true : false,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) =>
                            SelectContacts(grpName: widget.grpName)))
                    .then((_) async {
                  Navigator.of(context).pop();
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
            child: RefreshIndicator(
          onRefresh: () async {
            await cnst.initialize().then((value) => setState(() {}));
          },
          child: ListView.builder(
              padding: EdgeInsets.all(20),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: cnst
                  .final_val[cnst.group_unique[widget.grpName]]![
                      widget.user_email]!
                  .length,
              itemBuilder: (BuildContext context, int count) {
                if (cnst
                        .final_val[cnst.group_unique[widget.grpName]]![
                            widget.user_email]!
                        .length ==
                    0) {
                  return Container(
                      child: Align(
                    child: Text('No Contacts Shared By This User !'),
                    alignment: Alignment.center,
                  ));
                }
                return ListTile(
                  title: Text(cnst
                      .final_val[cnst.group_unique[widget.grpName]]![
                          widget.user_email]![count]
                      .contactName),
                  subtitle: Text(cnst
                      .final_val[cnst.group_unique[widget.grpName]]![
                          widget.user_email]![count]
                      .number),
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: cnst
                            .final_val[cnst.group_unique[widget.grpName]]![
                                widget.user_email]![count]
                            .number));
                            ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied To Clipboard !')));
                  },
                );
              }),
        )),
        floatingActionButton: new Visibility(
          visible: widget.user_email == cnst.currentUser!.email ? true : false,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          SelectContacts(grpName: widget.grpName)))
                  .then((_) {
                Navigator.of(context).pop();
              });
            },
          ),
        ));
  }
}
