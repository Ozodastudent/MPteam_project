import 'package:floor/floor.dart';

@entity
class ImagesListEntity {
  @PrimaryKey(autoGenerate: false)
  final String id;
  final String imageUrl;
  final bool isSelected;
  final int height;
  final int width;

  ImagesListEntity({
    required this.id,
    required this.imageUrl,
    required this.isSelected,
    required this.width,
    required this.height
  });

    factory ImagesListEntity.fromJson(Map<String, dynamic> json) => ImagesListEntity(
      id: json["id"],
      imageUrl: json['imageUrl'],
    isSelected: json['isSelected'],
    width: json['width'],
    height: json['height']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imageUrl": imageUrl,
    "isSelected": isSelected,
  };
  
}
