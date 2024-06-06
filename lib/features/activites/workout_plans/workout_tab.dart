import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/new_workout_provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/workout_list_provider.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/workout/add_workout_plan.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/workout/new_workout_sheet.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/workout/workout_plan_card.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';

class WorkoutTab extends StatelessWidget {
  const WorkoutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => WorkoutListProvider(),
        builder: (context, child) {
          context.read<WorkoutListProvider>().getWorkoutPlans();
          return Consumer<WorkoutListProvider>(
              builder: (context, provider, child) {
            return ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Strength Training",
                      style: AppTheme.boldText,
                    ),
                    Text(
                      "${provider.workout.length} workout",
                      style: AppTheme.greyText,
                    )
                  ],
                ),
                SizedBox(
                  height: AppSize.h10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    log(provider.workout[index].exercises!
                        .map(
                          (e) => e.sets,
                        )
                        .toString());
                    return InkWell(
                      onTap: () async {
                        context.read<NewWorkoutProvider>().excercies =
                            provider.workout[index].exercises ?? [];
                        await showCupertinoModalBottomSheet(
                          context: context,
                          expand: true,
                          builder: (context) => NewWorkoutSheet(
                            workoutId: provider.workout[index].id!,
                          ),
                        );
                        context.read<WorkoutListProvider>().getWorkoutPlans();
                      },
                      child: WorkoutPlan(
                        title: provider.workout[index].name ?? "",
                        exercises: provider.workout[index].exercises?.length
                                .toString() ??
                            "0",
                        sets: "${provider.workout[index].exercises!.map(
                              (e) => e.sets?.length ?? 0,
                            ).toList().isEmpty ? "0" : provider.workout[index].exercises?.map(
                              (e) => e.sets?.length ?? 0,
                            ).toList().reduce(
                              (value, element) => value + element,
                            ) ?? 0}",
                      ),
                    );
                  },
                  itemCount: provider.workout.length,
                ),
                SizedBox(
                  height: AppSize.h20,
                ),
                AddWorkoutPlan()
              ],
            );
          });
        });
  }
}
