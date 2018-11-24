import 'package:cat/common/net/net.dart';

class FeedBackResponse {
  final bool type;
  const FeedBackResponse({this.type});

  factory FeedBackResponse.fromJson(Map<String, dynamic> json) {
    print("FeedBackResponse.fromJson \n$json");
    var list = json['data'];
    return FeedBackResponse(
      type: json['type'],
    );
  }
}

class FeedBackService {
  static sendFeedBack(String title, String content) async {
    String url = Address.feedBack();
    Map<String, String> params = {"title": title, "content": content};

    final response =
        await HttpManager.request(Method.Post, url, params: params);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return FeedBackResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static sendWrongFeedBack() async {}
}
