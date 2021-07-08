import 'dart:async';
import 'constants.dart';
import 'home.dart';
import 'group_view.dart';
// import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Famtact',
      theme: ThemeData.dark(),
      home: SignInDemo()));
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
        currentUser = account;
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
              print("HEllooooooooo");
              if (snapshot.hasError) {
                print('You Have an error! ${snapshot.error.toString()}');
              } else if (snapshot.hasData) {
                return Scaffold(
                    appBar: AppBar(
                      title: const Text('Google Sign In'),
                    ),
                    body: ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: BuildBody(),
                    ));
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
  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   setState(() {
  //     _contactText = "Loading contact info...";
  //   });
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     setState(() {
  //       _contactText = "People API gave a ${response.statusCode} "
  //           "response. Check logs for details.";
  //     });
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data = json.decode(response.body);
  //   final String? namedContact = _pickFirstNamedContact(data);
  //   setState(() {
  //     if (namedContact != null) {
  //       print(data);
  //       _contactText = "I see you know $namedContact!";
  //     } else {
  //       _contactText = "No contacts to display.";
  //     }
  //   });
  // }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'];
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //         (dynamic contact) => contact['names'] != null,
  //     orElse: () => null,
  //   );
  //   if (contact != null) {
  //     final Map<String, dynamic>? name = contact['names'].firstWhere(
  //           (dynamic name) => name['displayName'] != null,
  //       orElse: () => null,
  //     );
  //     if (name != null) {
  //       return name['displayName'];
  //     }
  //   }
  //   return null;
  // }

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
    GoogleSignInAccount? user = currentUser;
    if (user != null) {
      print('the user id is' + currentUser!.id.toString());
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text("Signed in successfully."),
          Text(_contactText),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeReal()));
            }
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          ElevatedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }
}
