enum Environment {
  /// 开发环境
  dev,

  /// 测试环境
  test,

  /// 生产环境
  product,
}

class Config {
  static const Environment environment = Environment.dev;

  static get host {
    if (environment == Environment.dev) {
      return "https://shuatiapp.cn/";
    }
    if (environment == Environment.test) {
      return "https://shuatiapp.cn/";
    }
    if (environment == Environment.product) {
      return "https://shuatiapp.cn/";
    }

    /// 断言
    assert(environment != null, "缺少环境配置");
  }
}
