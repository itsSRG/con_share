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
  print('*******************************Printing everything in database*****************************************\n\n');
  print(snapshot.value);
  print('\n\n*******************************Printing everything in database*****************************************');
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
              if(key3 == 'none' && value3 == currentUser!.email)
              {
                ref.child(key).child('users').child(key2).set({currentUser!.id : currentUser!.email});
              }
              user_id[key]!.add(key3.toString());
              user_email[key]!.add(value3.toString());
            });
          });
        }
      });
    });
    Map<dynamic, dynamic>.from(snapshot.value).forEach((key, value) {
      Map<dynamic, dynamic>.from(value).forEach((key1, value1) {
        if (key1.toString() == 'contacts') {
          Map<dynamic, dynamic>.from(value1).forEach((key2, value2) {
            
            final_val[key]![
                user_email[key]![user_id[key]!.indexOf(key2.toString())]] = [];
            Map<dynamic, dynamic>.from(value2).forEach((key3, value3) {
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
  print('\n\nAll constants.dart print statements start\n\n');
  print('\n\ngroup_unique :\n\n');
  print(group_unique);
  print('\n\nuser_id :\n\n');
  print(user_id);
  print('\n\nuser_email :\n\n');
  print(user_email);
  print('\n\nfinal_val :\n\n');
  print(final_val);
  print('\n\nselected :\n\n');
  print(selected);
  print('\n\nAll constants.dart print statements end\n\n');
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
