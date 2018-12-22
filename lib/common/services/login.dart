import 'package:cat/common/net/net.dart';

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
  static login(String phone, String password) async {
    String url = Address.login();
    Map<String, String> params = {"account": phone, "password": password};
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
}
