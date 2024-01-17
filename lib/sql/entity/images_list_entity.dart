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
}
