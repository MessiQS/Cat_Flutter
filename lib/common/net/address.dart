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

  /// 更新服务端答题记录
  ///
  /// [paper_id] 试卷id
  /// [question_id] 试题id
  /// [question_number] 试题编号
  /// [weighted] 加权值
  /// [lastDateTime] 最后更新时间
  /// [record] JSON化后的答题记录
  /// [firstDateTime] 首次被选择的时间
  /// [POST] 请求方式
  static getUpdateInfoCache() {
    return "${Config.host}api/getUpdateInfoCache";
  }

  /// 反馈内容
  ///
  /// [user_id] 用户id
  /// [title] 标题
  /// [content] 内容
  /// [POST] 请求方式
  static feedBack() {
    return "${Config.host}api/feedback";
  }

  /// 错题反馈
  ///
  /// [title] 题目标题
  /// [id] 试题id
  /// [question_number] 试题号
  /// [user_id ] 用户id
  /// [POST] 请求方式
  static wrongFeedBack() {
    return "${Config.host}api/wrongFeedBack";
  }

  /// 获取验证码
  ///
  /// [account] 手机号
  /// [POST] 请求方式
  static getCaptcha() {
    return "${Config.host}api/getcode";
  }
}
