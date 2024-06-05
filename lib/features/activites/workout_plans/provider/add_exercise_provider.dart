import 'package:alphabet_index_listview/alphabet_index_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/shared/models/exercise_model.dart';
import 'package:workout_management/shared/provider/common_provider.dart';
import 'package:workout_management/shared/utils/navigator.dart';

class AddExcerciseProvider extends ChangeNotifier {
  AddExcerciseProvider() {
    alphabeticalExerciseList = fetchAlphabeticalExerciseList(AppNavigator
        .navigatorKey.currentContext!
        .read<CommonProvider>()
        .exercises);
  }

  List<ExerciseModel> selectedExercises = [];

  List<String> _selectedmuscles = [];

  List<String> get selectedmuscles => _selectedmuscles;

  set selectedmuscles(List<String> value) {
    _selectedmuscles = value;
    notifyListeners();
  }

  List<String> _selectedequipments = [];

  List<String> get selectedequipments => _selectedequipments;

  set selectedequipments(List<String> value) {
    _selectedequipments = value;
    notifyListeners();
  }

  List<AlphabetIndexGroup<ExerciseModel>> _alphabeticalExerciseList = [];

  List<AlphabetIndexGroup<ExerciseModel>> _filteredExerciseList = [];

  List<AlphabetIndexGroup<ExerciseModel>> get filteredExerciseList =>
      _filteredExerciseList;

  set filteredExerciseList(List<AlphabetIndexGroup<ExerciseModel>> value) {
    _filteredExerciseList = value;
    notifyListeners();
  }

  List<AlphabetIndexGroup<ExerciseModel>> get alphabeticalExerciseList =>
      _alphabeticalExerciseList;

  set alphabeticalExerciseList(List<AlphabetIndexGroup<ExerciseModel>> value) {
    _alphabeticalExerciseList = value;
    notifyListeners();
  }

  List<AlphabetIndexGroup<ExerciseModel>> fetchAlphabeticalExerciseList(
      List<ExerciseModel> exercises) {
    return AlphabetIndexTool.analyzeData(exercises, (data) => data.name ?? "");
  }

  void addExercise(ExerciseModel exercise) {
    selectedExercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(ExerciseModel exercise) {
    selectedExercises.removeWhere(
      (element) => element.id == exercise.id,
    );
    notifyListeners();
  }
}
