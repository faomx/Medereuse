
import 'package:medereuse/models/user_model.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();

  factory CurrentUser() => _instance;

  CurrentUser._internal();

  UserModel? user;
  String? selectedRole;
}
