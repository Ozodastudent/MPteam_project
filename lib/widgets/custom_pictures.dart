import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPictures {
  const CustomPictures._();

  static SvgPicture icChatSmile = SvgPicture.asset("assets/icons/chat_smile.svg");
  static SvgPicture icHome = SvgPicture.asset("assets/icons/home.svg");
  static SvgPicture icSearch = SvgPicture.asset("assets/icons/search.svg");
  static SvgPicture icProfile= SvgPicture.asset("assets/icons/profile.svg");

}

extension CustomSvg on SvgPicture {
  SvgPicture copyWith({
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    final picture = pictureProvider as ExactAssetPicture;
    if (colorFilter != null) {
      var colorString = "$colorFilter"
          .substring("$colorFilter".indexOf("value: Color(") + 13);
      colorString = colorString.substring(0, colorString.indexOf(")),"));
      color = color ?? Color(int.parse(colorString));
    }
    return SvgPicture.asset(
      picture.assetName,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      color: color,
    );
  }

  String get path => (pictureProvider as ExactAssetPicture).assetName;
}

extension Extension on Image {
  Image copyWith({
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image(
      image: image,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      color: color ?? this.color,
    );
  }

  String get path {
    final path = "$image";
    const key = ', name: "';
    if (path.contains(key)) {
      return path.substring(path.indexOf(key) + key.length, path.length - 2);
    }
    return "";
  }
}  
  