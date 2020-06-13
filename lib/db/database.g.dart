// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

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
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
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
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DeadlineDao _deadlineDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
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
            'CREATE TABLE IF NOT EXISTS `Deadline` (`id` INTEGER, `title` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DeadlineDao get deadlineDao {
    return _deadlineDaoInstance ??= _$DeadlineDao(database, changeListener);
  }
}

class _$DeadlineDao extends DeadlineDao {
  _$DeadlineDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _deadlineInsertionAdapter = InsertionAdapter(
            database,
            'Deadline',
            (Deadline item) =>
                <String, dynamic>{'id': item.id, 'title': item.title},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _deadlineMapper = (Map<String, dynamic> row) =>
      Deadline(row['id'] as int, row['title'] as String);

  final InsertionAdapter<Deadline> _deadlineInsertionAdapter;

  @override
  Future<List<Deadline>> findAllPersons() async {
    return _queryAdapter.queryList('SELECT * FROM Deadline',
        mapper: _deadlineMapper);
  }

  @override
  Stream<Deadline> findPersonById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Deadline WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'Deadline',
        isView: false,
        mapper: _deadlineMapper);
  }

  @override
  Future<void> insertPerson(Deadline person) async {
    await _deadlineInsertionAdapter.insert(person, OnConflictStrategy.abort);
  }
}
