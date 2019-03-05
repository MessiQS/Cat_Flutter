import 'package:http/http.dart' as http;
import 'package:cat/common/utils/system_global.dart';
import 'dart:core';
import 'package:cat/common/db/db.dart';

enum Method { Post, Get, Put, Delete }

///
/// 网络请求
///
class HttpManager {
  static request(Method method, url, {params}) async {
    /// 如果没有传参数，初始化Map
    if (params == null) {
      params = new Map<String, dynamic>();
    }

    /// 加载User
    UserProvider userProvider = new UserProvider();
    User user = await userProvider.getUser();
    print("user $user");

    if (user.userID != null) {
      params["user_id"] = user.userID;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'meta': configureMetaWithMeta()
    };

    if (user.token != null) {
      headers["Authorization"] = user.token;
    }

    headers["Authorization"] = "920603cb89871e19a7684dc757dade7c";
    params["user_id"] = "SS00000001";
    print("--------------------");
    print("url: \n" + url);
    print("method: \n" + method.index.toString());
    print("headers: \n" + headers.toString());
    print("params: \n" + params.toString());

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
      return http.get(newURL, headers: headers);
    }

    /// Put
    if (method == Method.Put) {
      return http.put(url, body: params, headers: headers);
    }

    /// Delete
    if (method == Method.Delete) {
      String param = componentsSeparatedByParam(params);
      String newURL = url;
      if (param != null && param.isEmpty == false) {
        newURL = url + "?" + param;
      }
      return http.delete(newURL, headers: headers);
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
    Map meta = {
      "platform": SystemClobal.platform,
      "locale_name": SystemClobal.localeName,
      "operating_system_version": SystemClobal.operatingSystemVersion,
      "number_of_processors": SystemClobal.numberOfProcessors,
      "current_req_time_ms": DateTime.now().millisecondsSinceEpoch.toString(),
    };

    return meta.toString();
  }
}
