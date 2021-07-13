import 'package:con_share/add_user.dart';
import 'package:flutter/material.dart';
import 'view_contact.dart';
import 'add_user.dart';
import 'constants.dart' as cnst;

class GorupView extends StatefulWidget {
  final String grpName;
  const GorupView({Key? key, required this.grpName}) : super(key: key);

  @override
  _GorupViewState createState() => _GorupViewState();
}

class _GorupViewState extends State<GorupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.grpName.toString()),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await cnst.initialize().then((value) => setState(() {}));
          },
          child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: cnst
                      .user_email[cnst.group_unique[widget.grpName]]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ContactView(
                                grpName: widget.grpName,
                                user_email: cnst.user_email[cnst
                                    .group_unique[widget.grpName]]![index])));
                      },
                      title: Center(
                        child: Text(
                            cnst.user_email[cnst.group_unique[widget.grpName]]![
                                    index]
                                .toString()),
                      ),
                    ));
                  }),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => AddUser(grpName: widget.grpName)))
                  .then((_) async {
                await cnst.initialize().then((value) => setState(() {}));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully Added')));
              });
            }));
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