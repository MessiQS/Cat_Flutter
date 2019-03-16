import 'package:cat/common/net/net.dart';
import 'dart:convert' as JSON;
import 'package:cat/common/services/answer.dart';
import 'package:cat/common/utils/crypto.dart';
import 'package:cat/common/db/db.dart';

class LoginResponse {
  final bool type;
  final dynamic data;
  const LoginResponse({this.type, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      type: json['type'],
      data: json['data'],
    );
  }
}

class LoginService {
  static isLogin() async {
    UserProvider userProvider = new UserProvider();

    User user = await userProvider.getUser();
    if (user.userID != null) {
      return true;
    } else {
      return false;
    }
  }

  static login(String phone, String password) async {
    String url = Address.login();
    String md5 = CryptoUtil.generateMd5(password);
    Map<String, String> params = {"account": phone, "password": md5};
    final response =
        await HttpManager.request(Method.Post, url, params: params);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  ///
  /// 同步数据
  ///
  static synchronizeNetworkData(String userId) async {
    LoginResponse response = await LoginService.getUserQuestionInfo(userId);
    Map map = response.data;
    Map userQuestionInfo = map["userQuestionInfo"];

    /// 通过keys去拿试卷信息
    for (String key in userQuestionInfo.keys) {
      Map examInfo = userQuestionInfo[key];

      /// 通过试卷获得试题
      for (String ekey in examInfo.keys) {
        var records = examInfo[ekey]["record"];
        final recordsJson = JSON.jsonDecode(records);
        for (var json in recordsJson) {
          int createTime = json["time"];
          bool isCorrect = json["isRight"];
          String options = json["select"];
          int questionId = int.parse(ekey);
          await AnswerService.saveRecordFromWeb(
              key, questionId, options, createTime, isCorrect);
        }
      }
    }
  }

  ///
  /// 获取用户试题信息
  ///
  static getUserQuestionInfo(String userId) async {
    String url = Address.getUserQuestionInfo();
    Map<String, String> params = {"user_id": userId};
    final response = await HttpManager.request(Method.Get, url, params: params);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static logout() async {
    QuestionProvider questionProvider = new QuestionProvider();
    RecordProvider recordProvider = new RecordProvider();
    UserProvider userProvider = new UserProvider();
    await questionProvider.deleteAll();
    await recordProvider.deleteAll();
    await userProvider.deleteAll();
  }
}
