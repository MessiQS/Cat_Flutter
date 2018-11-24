import 'package:cat/common/net/net.dart';

class SignUpService {
  static getCaptcha(String account) async {
    String url = Address.getCaptcha();
    Map<String, String> params = {"account": account};

    final response =
        await HttpManager.request(Method.Post, url, params: params);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
