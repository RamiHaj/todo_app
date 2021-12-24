import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Screens/Archived_Tasks.dart';
import 'package:todoapp/Screens/Done_Tasks.dart';
import 'package:todoapp/Screens/new_tasks.dart';
import 'package:todoapp/Shared/cubit/states.dart';

class Appcubit extends Cubit<Appstates>
{
  Appcubit() : super(AppInitialState());

  static Appcubit get(context) => BlocProvider.of(context);

  int currentindex = 0;

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks()
  ];

  List<String> Titles = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks"
  ];

  void changeindex(int index)
  {
    currentindex = index;
    emit(AppChangeIndex());
  }

  late Database database;

  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  void createdatabase(){
    openDatabase(
        "todo.db",
        version: 1,
        onCreate: (database, version) async
        {
          await database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)');
          print("Data Base Created");
        },
        onOpen: (database)
        {
          getdatabase(database);
          print("Data Base Opened");
        }
    ).then((value)
    {
      database = value;
      emit(AppCreateDataState());
    });
  }

  insertdatabase(
      {@required title, @required time, @required date}) async {
    return await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value){
          print("$value Inserted Successfully");
          emit(AppInsertDataState());
          getdatabase(database);
      }).catchError((error)
      {
        print('error when Inserting record ${error.toString()}');
      });
      return null;
    });
  }

  void getdatabase(database) {
    // emit(AppGetDataLoadingState());
    newtasks =[];
    donetasks=[];
    archivedtasks=[];
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      // var tasks = value;
      // print(tasks);
      // value.forEach((element){
      //   print(element['status']);
      // });
      value.forEach((element) {
        if (element['status'] == 'new'){
          newtasks.add(element);
          print(element);}
        else if (element['status'] == 'Done'){
          donetasks.add(element);
          print(element);}
        else{ archivedtasks.add(element);
        print(element);}
      });
      emit(AppGetDataState());
    });
  }

  void updatedatabase({
  required String status,
  required int id
    })
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value)
    {
      getdatabase(database);
      emit(AppUpdateDataState());
    });
  }

  void deletedatabase({
    required int id
  })
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getdatabase(database);
      emit(AppDeleteDataState());
    });
  }

  bool isbottomsheetshow = false;
  IconData fabicon = Icons.edit;

  void ChangeBottomSheetShow({
    required bool isshow,
    required IconData icon
  }
  )
  {
    isbottomsheetshow = isshow;
    fabicon = icon;
    emit(AppChangeBottomstate());
  }
}