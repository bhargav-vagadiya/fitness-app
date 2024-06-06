import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:workout_management/shared/helpers/sqlite_helper.dart';
import 'package:workout_management/shared/models/exercise_model.dart';
import 'package:workout_management/shared/utils/appdb.dart';

class NewWorkoutProvider extends ChangeNotifier {
  List<ExerciseModel> _excercies = [];

  List<ExerciseModel> get excercies => _excercies;

  set excercies(List<ExerciseModel> value) {
    _excercies = value;
    notifyListeners();
  }

  Future deleteExercise(String id) async {
    await SqliteHelper().deleteData(Appdb.exercise, "id = '$id'");
    notifyListeners();
  }
}
