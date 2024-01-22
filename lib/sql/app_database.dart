import 'dart:async';
import 'package:floor/floor.dart';
import 'package:MPteam_project/sql/data_access_object/images_list_dao.dart';
import 'package:MPteam_project/sql/entity/images_list_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'app_database.g.dart';

@Database(version: 1, entities: [ImagesListEntity])
abstract class AppDatabase extends FloorDatabase {
  ImagesListDao get imagesList;
}
