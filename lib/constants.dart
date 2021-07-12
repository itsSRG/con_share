import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

GoogleSignInAccount? currentUser;
Map<String?, List<bool>>? selected =
    {}; // stores what contacts are selected and what not
Map<String?, Map<String?, List<UserContactItem>>> final_val =
    {}; // stores all contacts for a group for a user
Map<String?, String?> group_unique = {}; // stores unique id for a group

Map<String?, List<String>> user_id = {};
Map<String?, List<String>> user_email = {};

Future<bool> initialize() async {
  selected = {};
  final_val = {};
  group_unique = {};
  user_id = {};
  user_email = {};
  var fb = FirebaseDatabase.instance;
  var ref = fb.reference().child('groups');
  var snapshot = await ref.once();
  print(snapshot.value);
  if (snapshot.value != null) {
    Map<dynamic, dynamic>.from(snapshot.value).forEach((key, value) {
      user_id[key] = [];
      user_email[key] = [];
      final_val[key] = {};
      Map<dynamic, dynamic>.from(value).forEach((key1, value1) {
        if (key1.toString() == 'group_name') {
          group_unique[value1] = key;
        }
        if (key1.toString() == 'users') {
          Map<dynamic, dynamic>.from(value1).forEach((key2, value2) {
            Map<dynamic, dynamic>.from(value2).forEach((key3, value3) {
              print('loop 1');
              print(key3);
              print(value3);
              print('loop 1');
              user_id[key]!.add(key3.toString());
              user_email[key]!.add(value3.toString());
            });
          });
        }
      });
    });
    Map<dynamic, dynamic>.from(snapshot.value).forEach((key, value) {
      Map<dynamic, dynamic>.from(value).forEach((key1, value1) {
        print('out of loop 1');
        print(user_id);
        print(user_email);
        print('out of loop 1');
        if (key1.toString() == 'contacts') {
          Map<dynamic, dynamic>.from(value1).forEach((key2, value2) {
            
            final_val[key]![
                user_email[key]![user_id[key]!.indexOf(key2.toString())]] = [];
            Map<dynamic, dynamic>.from(value2).forEach((key3, value3) {
              print('value3');
              print(key2 == currentUser!.id);
              print(key);
              print(user_id);
              print(user_email[key]![user_id[key]!.indexOf(key2.toString())]);
              Map<dynamic, dynamic>.from(value3).forEach((key4, value4) {
                final_val[key]![user_email[key]![
                        user_id[key]!.indexOf(key2.toString())]]!
                    .add(UserContactItem(contactName: key4, number: value4));
              });
            });
          });
        }
      });
    });
  }

  print(group_unique);
  print(user_id);
  print(user_email);
  print(final_val);
  print(selected);
  print('Printed Selected');
  return true;
}

class UserContactItem {
  final String contactName;
  final String number;

  UserContactItem({
    required this.contactName,
    required this.number,
  });
}
