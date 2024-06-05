import 'package:workout_management/shared/models/exercise_model.dart';

class WorkoutModel {
  int? id;
  String? name;
  List<ExerciseModel>? exercises;

  WorkoutModel({this.id, this.name, this.exercises});
}
