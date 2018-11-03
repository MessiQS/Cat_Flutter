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

  ///
  /// 获取折线图数据
  /// 今天需要练习的 Today Practice
  ///
  static Future<List<ChartElem>> fetchTPChartElems(String examID) async {
    RecordProvider recordProvider = RecordProvider();
    List<Record> list = await recordProvider.getRecords(examID);
    List<ChartElem> elems = List<ChartElem>();

    /// 获取今天时间戳
    DateTime now = new DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    int todayEpoch = today.millisecondsSinceEpoch;

    /// 二维数组
    List<List<Record>> recordLists = List<List<Record>>();
    int oneday = 24 * 60 * 60 * 1000;

    /// 分段
    for (Record record in list) {
      print("$record");
      for (int i = 0; i < 6; i++) {
        if (todayEpoch + (i * oneday) < record.createdTime &&
            record.createdTime < todayEpoch + ((i + 1) * oneday)) {
          print("record.createdTime $i");
          recordLists[i].add(record);
          continue;
        }
      }
    }
    print("$recordLists");

    for (int i = 0; i < recordLists.length; i++) {
      ChartElem elem = ChartElem(i, recordLists[i].length);
      print("$elem");
      elems.add(elem);
    }
    print("return elems $elems");
    return elems;
  }

  ///
  /// 获取折线图数据
  /// 遗忘曲线的
  /// Forgetting Curve from Today
  ///
  static Future<List<ChartElem>> fetchFCFTElems(String examID) async {
    RecordProvider recordProvider = RecordProvider();
  }
}

/// 记忆统计
class ChartElem {
  final int domain;
  final int questions;

  ChartElem(this.domain, this.questions);

  @override
  String toString() {
    // TODO: implement toString
    return '''
        =======================  ChartElem  =======================

        domain : $domain
        questions : $questions
      ''';
  }
}
