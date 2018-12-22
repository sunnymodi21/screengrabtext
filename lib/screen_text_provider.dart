import 'package:sqflite/sqflite.dart';

final String tableScreenText = 'screenText';
final String columnId = '_id';
final String columnText = 'text';
final String columnImagePath = 'imagepath';

class ScreenText {
  int id;
  String text='';
  String imagepath='';

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnText: text, columnImagePath: imagepath};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ScreenText();

  ScreenText.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    text = map[columnText];
    imagepath = map[columnImagePath];
  }
}

class ScreenTextProvider {
  Database db;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'screens.db';
    //await deleteDatabase(path);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableScreenText ( 
              $columnId integer primary key autoincrement, 
              $columnText text not null,
              $columnImagePath text not null)
            ''');
    });
  }

  Future<ScreenText> insert(ScreenText screenText) async {
    await this.open();
    screenText.id = await db.insert(tableScreenText, screenText.toMap());
    await db.close();
    return screenText;
  }

  Future<ScreenText> getScreenText(int id) async {
    await this.open();
    List<Map> elementScreenText = await db.query(tableScreenText,
        where: '$columnId = ?',
        whereArgs: [id]);
    await db.close();
    if (elementScreenText.length > 0) {
      return ScreenText.fromMap(elementScreenText.first);
    }
    return null;
  }

  Future<List<ScreenText>> getAllScreenText() async {
    await this.open();
    List<Map> allScreenText = await db.query(tableScreenText, orderBy:columnId+' desc');
    await db.close();
    List<ScreenText> screenTextList = [];
    allScreenText.forEach((element) {
      screenTextList.add(ScreenText.fromMap(element));
    });
    return screenTextList;
  }

  Future<int> delete(int id) async {
    await this.open();
    int result = await db.delete(tableScreenText, where: '$columnId = ?', whereArgs: [id]);
    await db.close();
    return result;
  }

  Future<int> update(ScreenText screenText) async {
    await this.open();
    int result = await db.update(tableScreenText, screenText.toMap(),
        where: '$columnId = ?', whereArgs: [screenText.id]);
    await db.close();
    return result;
  }

  Future close() async => db.close();
}
