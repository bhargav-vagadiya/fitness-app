import 'package:workout_management/shared/models/exercise_model.dart';

class WorkoutModel {
  int? id;
  String? name;
  List<ExerciseModel>? exercises;

  WorkoutModel({this.id, this.name, this.exercises});

  static WorkoutModel fromJson(Map<String, dynamic> json) => WorkoutModel(
      id: json['id'],
      name: json['name'],
      exercises: (json['excercises'] as List<Map<String, dynamic>>)
          .map((Map<String, dynamic> exercise) => ExerciseModel.fromSql(
              exercise,
              (json['sets'] as List<Map<String, dynamic>>)
                  .where(
                    (e) => e['e_id'] == exercise['eid'],
                  )
                  .toList()))
          .toList());
}
