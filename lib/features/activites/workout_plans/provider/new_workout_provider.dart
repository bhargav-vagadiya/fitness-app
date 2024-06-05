import 'package:flutter/material.dart';
import 'package:workout_management/shared/models/exercise_model.dart';

class NewWorkoutProvider extends ChangeNotifier {
  List<ExerciseModel> _excercies = [];

  List<ExerciseModel> get excercies => _excercies;

  set excercies(List<ExerciseModel> value) {
    _excercies = value;
    notifyListeners();
  }
}
