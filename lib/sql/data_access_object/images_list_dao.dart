import 'package:floor/floor.dart';
import 'package:pinterestmobile/sql/entity/images_list_entity.dart';

@dao
abstract class ImagesListDao {
  @Query('SELECT * FROM ImagesListEntity')
  Future<List<ImagesListEntity>?> allImagesList();

  @insert
  Future<void> insertImagesList(ImagesListEntity imageInsertEntity);

  @update
  Future<void> updateImagesList(ImagesListEntity imageUpdateEntity);

  @Query('DELETE FROM ImagesListEntity WHERE id = :id')
  Future<void> deleteById(String id);
}
