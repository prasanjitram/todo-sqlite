import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/Todo.dart';
import 'package:todo_app/model/task.dart';

class DatabaseHelper{
  @override
  int get schemaVersion => 2;
  Future<Database?> database() async{
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
        join(await getDatabasesPath(), 'toDo.db'),
        onCreate: (db, version) async {
        await db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        await db.execute('CREATE TABLE toDo(id INTEGER PRIMARY KEY, title TEXT, isDone INTEGER, taskId INTEGER)');
        },
      version: 1
    );
  }
  Future<int> insertTask(Task task) async{
    int taskId=0;
    Database? _db = await database();
    await _db!.insert('tasks', task.toMap(),conflictAlgorithm: ConflictAlgorithm.replace).then((value) => taskId=value);
    return taskId;
  }
  Future<void> updateDescription(int id, String value) async{
    Database? _db = await database();
    await _db!.rawUpdate("UPDATE TASKS SET description = '$value' WHERE id = '$id'");
  }
  Future<void> updateToDoDone(int id, int isDone) async{
    Database? _db = await database();
    await _db!.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> updateTaskTitle(int id, String value) async{
    Database? _db = await database();
    await _db!.rawUpdate("UPDATE TASKS SET title = '$value' WHERE id = '$id'");
  }
  Future<void> insertToDo(ToDo toDo) async{
    Database? _db = await database();
    await _db!.insert('toDo', toDo.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> deleteTask(int id) async{
    Database? _db = await database();
    await _db!.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM toDo WHERE id = '$id'");
  }

  Future<List<Task>> getTask() async{
    Database? _db = await database();
    List<Map<String,dynamic>> taskMap = await _db!.query('tasks');
    return List.generate(taskMap.length, (index){
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description']
      );
    } );

  }

  Future<List<ToDo>> getToDo(int taskId) async{
    Database? _db = await database();
    List<Map<String,dynamic>> toDoMap = await _db!.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(toDoMap.length, (index){
      return ToDo(
          id: toDoMap[index]['id'],
          title: toDoMap[index]['title'],
          isDone: toDoMap[index]['isDone'],
        taskId: toDoMap[index]['taskId']
      );
    } );

  }
}