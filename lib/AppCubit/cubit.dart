// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:note_app/AppCubit/state.dart';
// import 'package:note_app/Module/archived_plan.dart';
// import 'package:note_app/Module/done_plan.dart';
// import 'package:note_app/Module/new_plan.dart';
// import 'package:sqflite/sqflite.dart';

// class AppCubit extends Cubit<AppState> {
//   AppCubit() : super(AppInitialState());

//   static AppCubit get(context) => BlocProvider.of(context);

//   int curentIndex = 0;

//   List<Widget> screens = [
//     const NewTask(),
//     const DoneTask(),
//     const ArchivedTask()
//   ];

//   void changapp(int index) {
//     curentIndex = index;
//     emit(AppBottomNavState());
//   }

//   Database? database;

//   void showtost() {
//     Fluttertoast.showToast(
//         msg: 'Data Inserted', fontSize: 18.0, gravity: ToastGravity.BOTTOM);
//     emit(Showtostmassge());
//   }

//   void createdatabase() {
//     openDatabase(
//       'note.db',
//       version: 1,
//       onCreate: (database, version) {
//         print("DataBase Created");
//         database
//             .execute(
//                 'CREATE TABLE plans (id INTEGER PRIMARY KEY , title TEXT , date TEXT ,time TEXT ,status TEXT)')
//             .then((value) {
//           print("Table Created");
//         }).catchError((error) {
//           print("error is ${error.toString()}");
//         });
//       },
//       onOpen: (database) {
//         getdataformdatabase(database);
//         print("Database opened");
//       },
//     ).then((value) {
//       database = value;
//       emit(AppCreateDataBase());
//     });
//   }

//   void inserttodatabase({
//     required String title,
//     required String date,
//     required String time,
//   }) async {
//     await database!
//         .transaction((txn) => txn.rawInsert(
//             'INSERT INTO plans (title , date , time , status) VALUES ("$title" , "$date" , "$time" , "NEW")'))
//         .then((value) {
//       print("$value Inserted Successfully");
//       emit(AppInsretDataBase());

//       getdataformdatabase(database);
//     }).catchError((error) {
//       print("Error is ${error.toString()}");
//     });
//   }

//   List<Map> newplan = [];
//   List<Map> doneplan = [];
//   List<Map> archivedplan = [];
//   void getdataformdatabase(database) {
//     newplan = [];
//     doneplan = [];
//     archivedplan = [];
//     emit(AppLoading());
//     database.rawQuery('SELECT * FROM plans').then((value) {
//       value.forEach((element) {
//         if (element['status'] == 'new') {
//           newplan.add(element);
//         } else if (element['status'] == 'Done') {
//           doneplan.add(element);
//         } else {
//           archivedplan.add(element);
//         }
//       });

//       emit(AppGetDataBase());
//     });
//   }

//   void updatedata({required String status, required int id}) async {
//     database!.rawUpdate('UPDATE plans set status = ? WHERE id = ? ',
//         [status, id]).then((value) {
//       getdataformdatabase(database);
//       emit(AppUpdateDataBase());
//     });
//   }
// }




// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app/AppCubit/state.dart';

import 'package:sqflite/sqflite.dart';

import '../Module/archived_plan.dart';
import '../Module/done_plan.dart';
import '../Module/new_plan.dart';


class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [const NewTask(), const DoneTask(), const ArchivedTask()];

  

  Database? database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  void showtost() {
    Fluttertoast.showToast(
        msg: 'Data Inserted', fontSize: 18.0, gravity: ToastGravity.BOTTOM);
    emit(Showtostmassge());
  }

  void createdatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT  )')
            .then((value) {
          print("table created ");
        }).catchError((error) {
          print("error ${error.toString()}");
        });
      },
      onOpen: (database) {
        getdatafromdatabase(database);
        print("database opend");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBase());
    });
  }

  inserttodatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    await database!.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
            .then((value) {
          print("Data inserted Successfully");
          emit(AppInsretDataBase());

          getdatafromdatabase(database);
        }).catchError((error) { 
          print("Error ${error.toString()}");
        }));
  }

  void getdatafromdatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoading());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(AppGetDataBase());
    });
  }

  void updatedata({required String status, required int id}) async {
    database!.rawUpdate('UPDATE tasks set status = ? WHERE id = ? ',
        [status, id]).then((value) {
      getdatafromdatabase(database);
      emit(AppUpdateDataBase());
    });
  }

  void deletedata({required int id}) async {
    database!
        .rawDelete('DELETE FROM tasks WHERE id = ? ', [id]).then((value) {
      getdatafromdatabase(database);
      emit(AppDeleteDataBase());
    });
  }

  void changapp(int index) {
    currentIndex = index;
    emit(AppBottomNavState());
  }
  
}
