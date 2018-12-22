import 'package:cat/common/db/db.dart';

class UserDao {
  ///
  /// 存入数据库
  ///
  static saveUserToDB(String userID, String token) async {
    UserProvider userProvider = new UserProvider();
    User user = await userProvider.getUser();
    user.userID = userID;
    user.token = token;
    userProvider.update(user);
  }
}
