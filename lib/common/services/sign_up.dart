import 'package:cat/common/net/net.dart';
import 'package:cat/common/utils/crypto.dart';

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

class SignUpResponse {
  final bool type;
  final String data;
  const SignUpResponse({this.type, this.data});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      type: json['type'],
      data: json['data'],
    );
  }
}

class SignUpService {
  static String phone;
  static String captcha;
  static String password;

  static getCaptcha(String phone) async {
    String url = Address.getCaptcha();
    Map<String, String> params = {"account": phone};
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

  static signUp() async {
    String url = Address.signUp();
    String md5 = CryptoUtil.generateMd5(password);

    Map<String, String> params = {
      "account": phone,
      "password": md5,
      "vericode": captcha
    };
    final response =
        await HttpManager.request(Method.Post, url, params: params);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return SignUpResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
