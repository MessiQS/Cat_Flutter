class Address {
  static const String host = "https://shuatiapp.cn/";

  /// 获取试卷数据
  ///
  /// [paperId] 试卷id `SP00638`
  /// [GET] 请求方式
  static getpaper() {
    return "${host}api/getpaper";
  }

  static getUpdate() {
    return "${host}api/getUpdate"; 
  }

  /// 获取答题记录
  ///
  /// [paper_id] 试卷id `SP00638`
  /// [GET] 请求方式
  static getQuestionInfoByPaperid() {
    return "${host}api/getQuestionInfoByPaperid";
  }

  /// 获取试题种类 一二级
  ///
  /// [GET] 请求方式
  static getSecondType() {
    return "${host}api/getSecondType";
  }

  /// 通过一二级搜索三级内容
  ///
  /// [sendType] 第一级类型 `公考`
  /// [province] 第二级类型 `河南`
  /// [GET] 请求方式
  static getTitleByProvince() {
    return "${host}api/getTitleByProvince";
  }
}
