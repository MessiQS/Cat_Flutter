import 'package:cat/common/db/db.dart';

class StatisticsService {
  /// 获取当前用户
  static Future<User> fetchUser() async {
    UserProvider userProvider = new UserProvider();
    User user = await userProvider.getUser();

    if (user == null) {
      print("user is null");
    }
    return user;
  }

  /// 获取图表元素
  static Future<List<LinearQuestion>> fetchChartsElem(String examID) async {
    RecordProvider recordProvider = RecordProvider();

    List<Record> list = await recordProvider.getRecords(examID);
    print("records list $list examID: $examID");
  }
}

/// 记忆统计
class LinearQuestion {
  final String weekend;
  final int domain;
  final int questions;

  LinearQuestion(this.domain, this.weekend, this.questions);
}
