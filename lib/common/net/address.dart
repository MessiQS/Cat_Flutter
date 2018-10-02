class Address {
  static const String host = "https://shuatiapp.cn/";

  static getpaper() {
    return "${host}api/getpaper";
  }

  static getUpdate() {
    return "${host}api/getUpdate";
  }

  static getQuestionInfoByPaperid() {
    return "${host}api/getQuestionInfoByPaperid";
  }

  static getSecondType() {
    return "${host}api/getSecondType";
  }
  
  static getTitleByProvince() {
    return "${host}api/getTitleByProvince";
  }
}
