part of 'app_database.dart';

class $FloorAppDatabase {
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ImagesListDao? _imagesListInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ImagesListEntity` (`id` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `isSelected` INTEGER NOT NULL, `height` INTEGER NOT NULL, `width` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ImagesListDao get imagesList {
    return _imagesListInstance ??= _$ImagesListDao(database, changeListener);
  }
}

class _$ImagesListDao extends ImagesListDao {
  _$ImagesListDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _imagesListEntityInsertionAdapter = InsertionAdapter(
            database,
            'ImagesListEntity',
            (ImagesListEntity item) => <String, Object?>{
                  'id': item.id,
                  'imageUrl': item.imageUrl,
                  'isSelected': item.isSelected ? 1 : 0,
                  'height': item.height,
                  'width': item.width
                }),
        _imagesListEntityUpdateAdapter = UpdateAdapter(
            database,
            'ImagesListEntity',
            ['id'],
            (ImagesListEntity item) => <String, Object?>{
                  'id': item.id,
                  'imageUrl': item.imageUrl,
                  'isSelected': item.isSelected ? 1 : 0,
                  'height': item.height,
                  'width': item.width
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ImagesListEntity> _imagesListEntityInsertionAdapter;

  final UpdateAdapter<ImagesListEntity> _imagesListEntityUpdateAdapter;

    @override
  Future<List<ImagesListEntity>?> allImagesList() async {
    return _queryAdapter.queryList('SELECT * FROM ImagesListEntity',
        mapper: (Map<String, Object?> row) => ImagesListEntity(
            id: row['id'] as String,
            imageUrl: row['imageUrl'] as String,
            isSelected: (row['isSelected'] as int) != 0,
            width: row['width'] as int,
            height: row['height'] as int));
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ImagesListEntity WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertImagesList(ImagesListEntity imageInsertEntity) async {
    await _imagesListEntityInsertionAdapter.insert(
        imageInsertEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateImagesList(ImagesListEntity imageUpdateEntity) async {
    await _imagesListEntityUpdateAdapter.update(
        imageUpdateEntity, OnConflictStrategy.abort);
  }

}
