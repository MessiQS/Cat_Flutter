import 'dart:ui' show Color;

///
/// 调色板
///
class CatColors {
  CatColors._();

  /// 全局主色调
  /// RGB FF7B46
  static const Color globalTintColor = Color(0xFFFF7B46);

  /// TextField TextFromField 底部线默认情况下的颜色
  static const Color textFieldUnderLineEnableColor = Color(0xFFEBEBEB);

  /// TextField TextFromField 标题栏的颜色
  static const Color textFieldLabelColor = Color(0x32000000);

  /// TextField TextFromField 占位符的颜色
  static const Color textFieldPlaceHolderColor = Color(0xFFB9B9B9);

  /// TextField TextFromField 光标颜色
  static const Color textFieldCursorColor = Color(0x88FF7B46);

  /// 文本默认颜色
  static const Color textDefaultColor = Color(0xFF272727);

  /// 答案Section页面颜色
  static const Color answerSectionColor = Color(0xFFFAFAFA);

  /// cell 的 splash颜色
  static const Color cellSplashColor = Color(0x88607D8B);

  /// 视图默认背景颜色
  static const Color defaultBackgroundColor = Color(0xFFFAFAFA);
}
