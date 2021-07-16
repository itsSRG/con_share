// The project was earlier named con_share, but the final app is named ShareTact
// google-services.json file is confidential, thus removed from android/app, 
// thus needs to be downloaded while setting up your firebase project

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:con_share/group_view.dart';
import 'add_grp.dart';
import 'constants.dart' as cnst;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Famtact', theme: ThemeData.dark(), home: SignInDemo()));
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
String _contactText = '';

class SignInDemoState extends State<SignInDemo> {
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        cnst.currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('You Have an error! ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              return BuildBody();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class BuildBody extends StatefulWidget {
  // const _buildBody({Key key}) : super(key: key);

  @override
  _BuildBodyState createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    List<String> groups = [];
    List<String> groups_unique_string = [];
    GoogleSignInAccount? user = cnst.currentUser;
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('All Groups'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _handleSignOut();
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: cnst.initialize(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('You Have an error! ${snapshot.error.toString()}');
              } else if (snapshot.hasData) {
                Map<dynamic, dynamic>.from(cnst.group_unique)
                    .forEach((key, value) {
                  if (cnst.user_email[value]!
                      .contains(cnst.currentUser!.email)) {
                    groups.add(key);
                  }
                });
                return groups.length == 0
                    ? Column(
                        children: [
                            ElevatedButton(
                              child: Icon(Icons.refresh),
                              onPressed: () async {
                                await cnst
                                    .initialize()
                                    .then((value) => setState(() {}));
                              },
                            ),
                            SizedBox(height: 200,),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'No Groups Available ! Please Add A Group 😊',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ])
                    : Column(
                        children: [
                            ElevatedButton(
                              child: Icon(Icons.refresh),
                              onPressed: () async {
                                await cnst
                                    .initialize()
                                    .then((value) => setState(() {}));
                              },
                            ),
                            SizedBox(height: 200,), new ListView.builder(
                            padding: EdgeInsets.all(20),
                            shrinkWrap: true,
                            itemCount: groups.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  title: Center(
                                    child: Text(groups[index]),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => GorupView(
                                                grpName:
                                                    groups[index].toString())));
                                  },
                                ),
                              );
                            }),]
                      );
              }
              return CircularProgressIndicator();
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddGroup()))
                .then((value) => setState(() {}));
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Sharetact'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _handleSignOut();
              },
            )
          ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text(
                  "You Are Not Currently Signed In.\n\n Please Sign In 😊",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    _handleSignIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/google_logo.png"),
                          height: 35.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
        ),
      );
    }
  }
}
