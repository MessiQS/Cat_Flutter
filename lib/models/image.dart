enum ImageType {
  /// 网络
  network,

  /// 资源库
  asset,
}

///
/// 图片Model
///
class ImageModel {
  final double width;
  final double height;
  final String src;
  final ImageType type;

  const ImageModel({this.width, this.height, this.type, this.src});
}
