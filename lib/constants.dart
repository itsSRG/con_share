import 'package:google_sign_in/google_sign_in.dart';
GoogleSignInAccount? currentUser;
List<UserContactItem> final_val = [];
GoogleSignInAccount? _currentUser;
List<bool>? selected;

class UserContactItem {
  final String contactName;
  final String number;

  UserContactItem({
    required this.contactName,
    required this.number,
  });
}
