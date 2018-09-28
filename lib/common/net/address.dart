import 'package:http/http.dart' as http;

class Address {

  static const String host = "https://shuatiapp.cn/";

  static getpaper(paperId) {
    return "${host}api/getpaper?paperId=$paperId";
  }

  static getUpdate(version) {
    return "${host}api/getUpdate?version=$version";
  }

  static getQuestionInfoByPaperid(paper_id) {
    return "${host}api/getQuestionInfoByPaperid?paper_id=$paper_id";
  }
}