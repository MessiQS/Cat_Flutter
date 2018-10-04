import 'package:http/http.dart' as http;
import 'package:cat/common/utils/system_global.dart';
import 'dart:core';

enum Method { Post, Get, Put, Delete }

///
/// 网络请求
///
class HttpManager {
  static const token = "192250d6b4a327c19297338f36070e4b";
  static const user_id = "SS00000656";

  static request(Method method, url, {params}) {
    /// 如果没有传参数，初始化Map
    if (params == null) {
      params = new Map<String, dynamic>();
    }

    if (user_id != null) {
      params["user_id"] = user_id;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'meta':configureMetaWithMeta()
    };

    if (token != null) {
      headers["Authorization"] = token;
    }

    /// Post
    if (method == Method.Post) {
      return http.post(url, body: params, headers: headers);
    }

    /// Get
    if (method == Method.Get) {
      String param = componentsSeparatedByParam(params);
      String newURL = url;
      if (param != null && param.isEmpty == false) {
        newURL = url + "?" + param;
      }
      print("newURL: " + newURL);
      return http.get(newURL, headers: headers);
    }
  }

  ///
  /// 拼接Get请求的字符串
  ///
  static componentsSeparatedByParam(Map<String, dynamic> map) {
    List<String> list = new List<String>();
    void iterateMapEntry(key, value) {
      // value 是 String 类型
      if (value != null && value is String) {
        String tranferValues = "$key=$value";
        list.add(tranferValues);
        return;
      }
      // value 是 int 类型
      if (value is List) {
        String tranferValues = value.map((i) => i.toString()).join(",");
        list.add(tranferValues);
        return;
      }
      // value 是 Map 递归处理
      if (value is Map) {
        String tranferValues = componentsSeparatedByParam(value);
        list.add(tranferValues);
        return;
      }

      // 其他类型 numeric etc.
      String tranferValues = "$key=${value.toString()}";
      list.add(tranferValues);
    }

    map.forEach(iterateMapEntry);

    return list.join("&");
  }

  static configureMetaWithMeta() {
    DateTime now = new DateTime.now();
    Map meta = {
      "platform": SystemClobal.platform,
      "locale_name": SystemClobal.localeName,
      "operating_system_version": SystemClobal.operatingSystemVersion,
      "number_of_processors": SystemClobal.numberOfProcessors,
      "current_req_time_ms":now.millisecondsSinceEpoch.toString(),
    };

    return meta.toString();
  }
}
