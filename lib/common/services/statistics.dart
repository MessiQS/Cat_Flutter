import 'package:cat/common/db/db.dart';

class StatisticsService {
  static Map<int, String> weekend = {
    -6: "MON",
    -5: "TUE",
    -4: "WED",
    -3: "THU",
    -2: "FRI",
    -1: "SAT",
    0: "SUN",
    1: "MON",
    2: "TUE",
    3: "WED",
    4: "THU",
    5: "FRI",
    6: "SAT",
    7: "SUN",
    8: "MON",
    9: "TUE",
    10: "WED",
    11: "THU",
    12: "FRI",
    13: "SAT",
    14: "SUN"
  };

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
    List<Record> list = await recordProvider.getUniqueRecords(examID);
    List<ChartElem> elems = List<ChartElem>();

    /// 获取今天时间戳
    DateTime now = new DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    int todayEpoch = today.millisecondsSinceEpoch;

    /// 二维数组
    List<List<Record>> recordLists = [
      List<Record>(),
      List<Record>(),
      List<Record>(),
      List<Record>(),
      List<Record>(),
      List<Record>(),
    ];
    int oneday = 24 * 60 * 60 * 1000;

    /// 分段
    for (Record record in list) {
      print("$record");
      for (int i = 5; i < 0; i++) {
        if (todayEpoch + (i * oneday) < record.createdTime &&
            record.createdTime < todayEpoch + ((i + 1) * oneday)) {
          recordLists[i].add(record);
          // continue;
        }
      }
    }
    print("recordLists $recordLists");

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

  static Future<List<String>> getTodayChartWeekday() async {
    List<String> list = [];

    DateTime now = new DateTime.now();
    for (int i = 0; i < 6; i++) {
      int j = now.weekday - i + 7;
      list.add(weekend[j]);
    }
    return list.reversed.toList();
  }
}

/// 记忆统计
class ChartElem {
  final int domain;
  final int count;

  ChartElem(this.domain, this.count);

  @override
  String toString() {
    return '''
        =======================  ${this.runtimeType}  =======================

        domain : $domain
        count : $count
      ''';
  }
}
