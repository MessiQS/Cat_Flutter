import 'package:cat/common/config/config.dart';

class Address {
  /// 获取试卷数据
  ///
  /// [paperId] 试卷id `SP00638`
  /// [GET] 请求方式
  static getpaper() {
    return "${Config.host}api/getpaper";
  }

  static getUpdate() {
    return "${Config.host}api/getUpdate";
  }

  /// 获取答题记录
  ///
  /// [paper_id] 试卷id `SP00638`
  /// [GET] 请求方式
  static getQuestionInfoByPaperid() {
    return "${Config.host}api/getQuestionInfoByPaperid";
  }

  /// 获取试题种类 一二级
  ///
  /// [GET] 请求方式
  static getSecondType() {
    return "${Config.host}api/getSecondType";
  }

  /// 通过一二级搜索三级内容
  ///
  /// [sendType] 第一级类型 `公考`
  /// [province] 第二级类型 `河南`
  /// [GET] 请求方式
  static getTitleByProvince() {
    return "${Config.host}api/getTitleByProvince";
  }
}
