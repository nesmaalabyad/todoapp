
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/cubit/states.dart';

import '../screens/archived_tasks_screen.dart';
import '../screens/done_tasks_screen.dart';
import '../screens/new_tasks_screen.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<String> title = ['To Do List', 'Done Tasks', 'Archived Tasks'];
  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
      )
          .then((value) {
        print('Table Created');
      }).catchError((error) {
        print('Error While Creating Table ${error.toString()}');
      });
      print('Database Created');
    }, onOpen: (database) {
      getDataFromDatabase(database).then((value) {
        value.forEach((element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });
        emit(AppGetDatabaseState());
      });
      print('Database Opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database).then((value) {
          value.forEach((element) {
            if (element['status'] == 'new') {
              newTasks.add(element);
            } else if (element['status'] == 'done') {
              doneTasks.add(element);
            } else {
              archivedTasks.add(element);
            }
          });
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks') as List<Map>;
    //print(tasks);
  }

  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database).then((value) {
        value.forEach((element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });
        emit(AppGetDatabaseState());
      });
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database).then((value) {
        value.forEach((element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });
        emit(AppGetDatabaseState());
      });
      emit(AppDeleteDatabaseState());
    });
  }
}
