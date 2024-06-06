import 'package:flutter/material.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';

class WorkoutPlan extends StatelessWidget {
  const WorkoutPlan(
      {super.key,
      required this.title,
      required this.exercises,
      required this.sets});

  final String title;
  final String exercises;
  final String sets;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(AppSize.sp10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.boldText,
                ),
                Text(
                  "$exercises exercises, $sets sets",
                  style: AppTheme.greyText,
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: AppSize.sp20,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
