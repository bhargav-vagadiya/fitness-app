import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter/services.dart';
import 'package:workout_management/shared/helpers/sqlite_helper.dart';
import 'package:workout_management/shared/models/exercise_model.dart';

class CommonProvider extends ChangeNotifier {
  List<ExerciseModel> _exercises = [];
  List<Muscle> muscles = [];
  List<Category> equipments = [];

  List<ExerciseModel> get exercises => _exercises;

  set exercises(List<ExerciseModel> value) {
    _exercises = value;
    notifyListeners();
  }

  Future<bool> loadExercises() async {
    var encodedJson = await rootBundle.loadString("assets/exercise.json");
    var decodedJson = jsonDecode(encodedJson);
    exercises =
        exerciseModelFromJson(jsonEncode(decodedJson['entity']['data']));

    try {
      await SqliteHelper().insertData(
          "Muscles",
          exercises
              .map((e) => e.mainMuscles)
              .expand((element) => [...element!])
              .toList()
              .map(
                (e) => e.toSql(),
              )
              .toList());
      await SqliteHelper().insertData(
          "Equipment",
          exercises
              .map((e) => e.equipments)
              .expand((element) => [...element!])
              .toList()
              .map(
                (e) => e.toSql(),
              )
              .toList());
    } catch (e) {
      log(e.toString());
    }

    muscles = (await SqliteHelper().readData("Muscles"))
        .map((e) => Muscle.fromJson(e))
        .toList();

    equipments = (await SqliteHelper().readData("Equipment"))
        .map((e) => Category.fromJson(e))
        .toList();

    notifyListeners();

    return true;
  }
}
