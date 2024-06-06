import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:workout_management/shared/helpers/sqlite_helper.dart';
import 'package:workout_management/shared/models/exercise_model.dart';
import 'package:workout_management/shared/models/workout_model.dart';
import 'package:workout_management/shared/utils/appdb.dart';

class WorkoutListProvider extends ChangeNotifier {
  List<WorkoutModel> _workout = [];

  List<WorkoutModel> get workout => _workout;

  set workout(List<WorkoutModel> value) {
    _workout = value;
    notifyListeners();
  }

  Future getWorkoutPlans() async {
    var workouts = await SqliteHelper()
        .readDataByRawQuery("select * from ${Appdb.workout}");
    var excercises = await SqliteHelper().readDataByRawQuery(
        """SELECT ${Appdb.exercise}.id as eid, ${Appdb.exercise}.name as ename, ${Appdb.workout}.id as wid
FROM ${Appdb.workout} LEFT JOIN ${Appdb.exercise} ON ${Appdb.workout}.id = ${Appdb.exercise}.w_id;
""");
    var sets =
        await SqliteHelper().readDataByRawQuery("select * from ${Appdb.sets}");

    workout = workouts
        .map((e) => WorkoutModel.fromJson({
              ...e,
              ...{
                "excercises": excercises
                    .where(
                      (element) =>
                          element['eid'] != null && element['wid'] == e['id'],
                    )
                    .toList(),
                "sets": sets
              }
            }))
        .toList();
  }

  addExcercies(List<ExerciseModel> excercies, int id) async {
    //  exercise (id TEXT, name text,w_id int,reorder_no int,foreign key(w_id) references Workout(id)
    //  Sets (kg int,reps int,e_id int,foreign key(e_id) references exercise(id))
    try {
      await SqliteHelper().insertData(
          Appdb.exercise,
          excercies
              .map(
                (e) => {
                  ...e.toSql(),
                  ...{"w_id": id}
                },
              )
              .toList());
      await SqliteHelper().insertData(
          Appdb.sets,
          excercies
              .map((e) => e.sets!
                  .map((s) => {
                        ...s.toJson(),
                        ...{"e_id": e.id}
                      })
                  .toList())
              .expand((element) => element)
              .toList());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteWorkOut(String table, String where) async {
    await SqliteHelper().deleteData(table, where);
    getWorkoutPlans();
    notifyListeners();
  }

  Future<void> updateWorkout(
      String table, List<Map<String, dynamic>> values, int workoutid) async {
    await SqliteHelper().updateData(table, values, workoutid);
    getWorkoutPlans();
    notifyListeners();
  }
}
