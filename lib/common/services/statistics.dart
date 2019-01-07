import 'package:cat/common/db/db.dart';

enum WeekdayType { Before, After }

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
      for (int i = 0; i < 5; i++) {
        if (record.createdTime > todayEpoch - (i * oneday) &&
            record.createdTime < todayEpoch - ((i - 1) * oneday)) {
          recordLists[i].add(record);
          continue;
        }
      }
    }

    for (int i = 0; i < recordLists.length; i++) {
      ChartElem elem = ChartElem(5 - i, recordLists[i].length);
      elems.add(elem);
    }
    return elems;
  }

  ///
  /// 获取折线图数据
  /// 遗忘曲线的
  /// Forgetting Curve from Today
  ///
  static Future<List<ChartElem>> fetchFCFTElems(String examID) async {
    RecordProvider recordProvider = RecordProvider();

    /// 按照question id排序，为了后面分组过滤
    List<Record> list =
        await recordProvider.getRecordsOrderBy(examID, RC.columnQuestionId);
    List<ChartElem> elems = List<ChartElem>();

    /// x 代表已经完成的试题总量
    /// y 代表做过但是未完成的试题总量
    int x = 0, y = 0;
    int questionId = -1;

    /// 当前权重
    int weighting = 7;
    int currentQuestionWeighting = 0;
    for (Record record in list) {
      if (questionId == record.questionId) {
        if (record.isCorrect == true) {
          currentQuestionWeighting += weighting;
        } else {
          weighting -= 1;
        }

        continue;
      }
      questionId = record.questionId;
      if (currentQuestionWeighting < 7) {
        y += 1;
      } else {
        x += 1;
      }
    }

    List<int> fcftList = [];

    fcftList.add(x + y);
    fcftList.add((x + (0.6 * y)).round());
    fcftList.add((x + (0.45 * y)).round());
    fcftList.add((x + (0.36 * y)).round());
    fcftList.add((x + (0.34 * y)).round());
    fcftList.add((x + (0.28 * y)).round());

    for (int i = 0; i < 5; i++) {
      ChartElem elem = ChartElem(i, fcftList[i]);
      elems.add(elem);
    }
    return elems;
  }

  static Future<List<ChartElem>> fetchEChartElems(
      String examID, WeekdayType type) async {
    if (type == WeekdayType.After) {
      return StatisticsService.fetchFCFTElems(examID);
    }

    if (type == WeekdayType.Before) {
      return StatisticsService.fetchTPChartElems(examID);
    }

    return [];
  }

  /// 获取从今天开始到过去五天的全部星期
  static List<String> getTodayBeforeWeekday() {
    List<String> list = [];

    DateTime now = new DateTime.now();
    for (int i = 0; i < 6; i++) {
      int j = now.weekday - i + 7;
      list.add(weekend[j]);
    }
    return list.reversed.toList();
  }

  /// 获取从今天开始到未来五天的全部星期
  static List<String> getTodayAfterWeekday() {
    List<String> list = [];

    DateTime now = new DateTime.now();
    for (int i = 0; i < 6; i++) {
      int j = now.weekday + i;
      list.add(weekend[j]);
    }
    return list;
  }

  /// 获取未来五天的星期
  static List<String> getWeekday(WeekdayType type) {
    if (type == WeekdayType.Before) {
      return StatisticsService.getTodayBeforeWeekday();
    }

    if (type == WeekdayType.After) {
      return StatisticsService.getTodayAfterWeekday();
    }

    return [];
  }

  static todayPraticeCount(String examID) async {
    RecordProvider recordProvider = RecordProvider();

    List<Record> list =
        await recordProvider.getRecordsOrderBy(examID, RC.columnQuestionId);

    List<Record> uniqueList = List();
    String currentQuestionID = "";
    for (Record record in list) {
      if (record.examId != currentQuestionID) {
        uniqueList.add(record);
        currentQuestionID = record.examId;
      }
    }

    return uniqueList.length;
  }

  static futurePracticeCount(String examID) async {
    RecordProvider recordProvider = RecordProvider();
    List<Record> list =
        await recordProvider.getRecordsOrderBy(examID, RC.columnQuestionId);

    for (Record record in list) {}
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
