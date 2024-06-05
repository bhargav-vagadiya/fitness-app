import 'package:alphabet_index_listview/alphabet_index_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/add_exercise_provider.dart';
import 'package:workout_management/shared/models/exercise_model.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';
import 'package:collection/collection.dart';

class ExerciseListView extends StatelessWidget {
  const ExerciseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AddExcerciseProvider>(
          builder: (context, workoutPlanProvider, child) {
        return AlphabetIndexListView(
          stickHeader: false,
          dataList: workoutPlanProvider.filteredExerciseList.isEmpty
              ? workoutPlanProvider.alphabeticalExerciseList
              : workoutPlanProvider.filteredExerciseList,
          groupBuilder: (int groupIndex, String tag) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                tag,
                style: AppTheme.boldText,
              ),
            );
          },
          childBuilder:
              (int groupIndex, int childIndex, ExerciseModel exercise) {
            bool itemContains =
                workoutPlanProvider.selectedExercises.firstWhereOrNull(
                      (element) => element.id == exercise.id,
                    ) !=
                    null;
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: CheckboxListTile.adaptive(
                tileColor:
                    itemContains ? Colors.deepOrange.withOpacity(0.1) : null,
                activeColor: Colors.deepOrange,
                shape: itemContains
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.r20),
                        side: const BorderSide(color: Colors.deepOrange))
                    : null,
                value: itemContains,
                onChanged: (value) {
                  bool itemContains =
                      workoutPlanProvider.selectedExercises.firstWhereOrNull(
                            (element) => element.id == exercise.id,
                          ) !=
                          null;
                  if (itemContains) {
                    workoutPlanProvider.removeExercise(exercise);
                  } else {
                    workoutPlanProvider.addExercise(exercise);
                  }
                },
                title: Text(exercise.name ?? ""),
              ),
            );
          },
        );
      }),
    );
  }
}
