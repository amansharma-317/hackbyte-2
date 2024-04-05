import 'package:hackbyte2/core/models/user_model.dart';

abstract class UserRepository {
  Future<UserProfile?> getUserData();
  Future<UserProfile?> getOtherUserData(String userId);
}