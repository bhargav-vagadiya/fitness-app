import 'package:flutter/material.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';

class WorkoutPlan extends StatelessWidget {
  const WorkoutPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(AppSize.sp10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Workout",
                  style: AppTheme.boldText,
                ),
                Text(
                  "5 exercises, 7 sets",
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
