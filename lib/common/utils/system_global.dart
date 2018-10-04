import 'dart:io' show Platform;

class SystemClobal {
  /// 获取操作系统
  static String get platform => Platform.operatingSystem;

  /// 获取名称
  static String get localeName => Platform.localeName;

  /// 操作系统版本
  static String get operatingSystemVersion => Platform.operatingSystemVersion;

  /// 处理器数量
  static String get numberOfProcessors =>
      Platform.numberOfProcessors.toString();  
  
}
