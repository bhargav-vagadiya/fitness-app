import 'package:flutter/material.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/workout/add_workout_plan.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/workout/workout_plan_card.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';

class WorkoutTab extends StatelessWidget {
  const WorkoutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Strength Training",
              style: AppTheme.boldText,
            ),
            Text(
              "1 workout",
              style: AppTheme.greyText,
            )
          ],
        ),
        SizedBox(
          height: AppSize.h10,
        ),
        const WorkoutPlan(),
        SizedBox(
          height: AppSize.h20,
        ),
        AddWorkoutPlan()
      ],
    );
  }
}
