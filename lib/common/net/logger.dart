// import 'dart:io';

// class Logger {
//   info() {}

//   verbose() {}

//   warning() {}

//   error() {}

//   static logWithSuccessRequest() {

//   }
// }
class Logger {
  final String name;
  bool mute = false;
  static final Map<String, Logger> _cache = <String, Logger>{}; // 缓存保存对象
  factory Logger(String name) {
    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final logger = new Logger._internal(name);
      _cache[name] = logger;
      return logger;
    }
  }
  Logger._internal(this.name); // 命名构造函数
  void log(String msg) {
    if (!mute) {
      print(msg);
    }
  }
}
