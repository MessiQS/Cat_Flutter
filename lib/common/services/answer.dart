import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cat/models/image.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/common/net/net.dart';
import 'package:cat/common/config/config.dart';

/// 试题类型
enum AnswerType {
  /// 学习过的题
  studied,

  /// 没有学习过的题
  neverStudied
}

/// 段落类型
enum ParagraphsType {
  /// 图片
  image,

  /// 文字
  text,

  /// HTML格式富文本
  html,
}

class AnswerService {
  ///
  /// 通过id从数据库中获取随机试题
  ///
  static Future<Question> fetchData(examID, {AnswerType type}) async {
    QuestionProvider questionProvider = new QuestionProvider();
    RecordProvider recordProvider = new RecordProvider();

    /// 获取对应试卷的所有试题
    List<Question> list = await questionProvider.getQuestions(examID);
    List<Record> recordList = await recordProvider.getRecords(examID);
    List<String> recordExamIds = List<String>();
    if (recordList.isEmpty == false) {
      recordExamIds = recordList.map((value) => value.examId);
    }

    /// 获取所有做过记录
    /// 去重
    List<String> unique = List<String>();
    recordExamIds.forEach((str) {
      if (unique.contains(str) == false) {
        unique.add(str);
      }
    });
    if (list.isEmpty == false) {
      Random random = new Random();
      int number = random.nextInt(list.length - 1);
      Question question = list[number];
      // Question question = list[58];

      print("${question}");
      return question;
    }
    return null;
  }

  ///
  /// 是否为多选题
  ///
  static bool isHaveMutilpleAnswer(Question question) {
    if (question.type == "不定项") {
      return true;
    }

    if (question.content.indexOf("不定项选择") != -1) {
      return true;
    }

    if (question.type.indexOf("多选") != -1) {
      return true;
    }

    List<String> list = question.content.split(",");
    if (list.length > 1) {
      return true;
    }
    return false;
  }

  ///
  /// 通过字符串 截取所需要的数据
  /// 转换成Image模型
  ///
  static ImageModel getImageModelFromParagraphs(
      String paragraphs, BuildContext context) {
    ///
    /// 到这步获得的字符串样子
    /// [paragraphs]
    /// alt="" class=""
    /// src="./images/56db380cf50180a7/normal_557x558_30fe67d42d27835b8fdc6b883417feff.png"
    /// width="329" height="330"
    ///
    RegExp regExp = new RegExp(
      r'src\s*=\s*"(.+?)"',
      caseSensitive: false,
      multiLine: false,
    );

    String str = regExp.firstMatch(paragraphs).group(0);

    ///
    /// 提取完成后的src
    /// https://shuatiapp.cn/images/56db380cf50180a7/normal_583x673_a768f839ffb619572cc196a2478daff7.png
    ///
    String src = str.replaceAll('src="./', Config.host).replaceAll('"', "");

    print("paragraphs" + paragraphs);

    double maxWidth = MediaQuery.of(context).size.width - 48;
    double width = 200.0;
    double height = 200.0;

    ///
    /// `公务员考试题`
    RegExp sizeRegExp = new RegExp(
      r'/(normal|formula)_(.*)x(.*)_',
      caseSensitive: false,
      multiLine: false,
    );

    /// 如果能匹配到相应的格式
    if (sizeRegExp.hasMatch(src)) {
      ///
      /// 截取的字符串
      /// [例子] normal_595x154_ formula_595x154_
      ///
      Match match = sizeRegExp.firstMatch(src);
      String finder = match.group(0);

      ///
      /// [type]
      /// [例子] normal or formula
      String type = finder.split("_").first.replaceAll("/", "");

      /// [例子] 595x154
      String size = finder.split("_")[1];
      String strWidth = size.split("x").first;
      String strHeight = size.split("x").last;

      /// 缩放到指定倍数
      width = double.parse('$strWidth');
      height = double.parse('$strHeight');

      if (type == "normal") {
        width = width * 0.7;
        height = height * 0.7;
      }
      if (type == "formula") {
        width = width * 0.3;
        height = height * 0.3;
      }

      /// 设置最大尺寸上限
      width = min(maxWidth, width);
    }
    return ImageModel(
        height: height, width: width, src: src, type: ImageType.network);
  }

  ///
  /// 清洗脏数据
  ///
  static List<String> splitContent(String content) {
    content = content
        .replaceAll("<br>", "\n\n")
        .replaceAll("<br/>", "\n\n")
        .replaceAll("</br>", "\n\n");

    List<String> newList = List<String>();
    List<String> list = content.split("<img");
    for (String str in list) {
      /// 不包含图片
      if (str.indexOf("/>") == -1) {
        newList.add(str);
      } else {
        List<String> splitList = str.split("/>");
        splitList.forEach((s) => newList.add(s));
      }
    }
    return newList;
  }

  ///
  /// 保存答题记录到数据库
  ///
  static saveRecordToDB(Question question, List<String> options) async {
    /// 判断答案是否正确
    bool isCorrect = true;
    List<String> answerList = question.answer.split(",");
    for (String answer in answerList) {
      if (options.indexOf(answer) == -1) {
        isCorrect = false;
      }
    }

    /// 保存到本地数据库
    Map map = {
      RC.columnExamID: question.examID,
      RC.columnQuestionId: question.id,
      RC.columnSelectedOption: options.join(","),
      RC.columnCreatedTime: DateTime.now().millisecondsSinceEpoch.toString(),
      RC.columnIsCorrect: isCorrect,
    };
    Record record = Record.fromMap(map);
    RecordProvider provider = RecordProvider();
    await provider.insert(record);
  }

  ///
  /// 保存答题记录到服务端
  ///
  static saveRecordToWeb(Question question, List<String> options) async {
    /// 获取相关的答题记录
    RecordProvider provider = RecordProvider();
    List<Record> list = await provider.getRecordsByQuestionId(question.id.toString());

    /// 配置网络数据
    String url = Address.getUpdateInfoCache();
    Map<String, String> params = {
      "paper_id": question.examID,
      "question_id": question.id.toString(),
      "question_number": question.number.toString(),
      "weighted": "",
      "lastDateTime": "",
      "record": "",
      "firstDateTime": "",
    };
    HttpManager.request(Method.Post, url, params: params);
  }
}
