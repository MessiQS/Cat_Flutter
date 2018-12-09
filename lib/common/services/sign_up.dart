import 'package:cat/common/net/net.dart';

class GetCaptchaResponse {
  final bool type;
  final String data;
  const GetCaptchaResponse({this.type, this.data});

  factory GetCaptchaResponse.fromJson(Map<String, dynamic> json) {
    return GetCaptchaResponse(
      type: json['type'],
      data: json['data'],
    );
  }
}

class SignUpService {
  static getCaptcha(String phone) async {
    String url = Address.getCaptcha();
    Map<String, String> params = {"account": phone};
    print(url);
    final response =
        await HttpManager.request(Method.Post, url, params: params);
    print("json.decode(response.body) ${json.decode(response.body)}");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return GetCaptchaResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static signIn(String phone, String captcha, String password) async {
    String url = Address.signUp();

    Map<String, String> params = {
      "account": phone,
      "password": password,
      "vericode": captcha
    };
    final response =
        await HttpManager.request(Method.Post, url, params: params);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return GetCaptchaResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
