import 'package:floor/floor.dart';
import 'package:pinterestmobile/sql/entity/images_list_entity.dart';

@dao
abstract class ImagesListDao {
  @Query('SELECT * FROM ImagesListEntity')
  Future<List<ImagesListEntity>?> allImagesList();

  @insert
  Future<void> insertImagesList(ImagesListEntity imageInsertEntity);
  
}
