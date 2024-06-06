import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/new_workout_provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/workout_list_provider.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/workout/new_workout_sheet.dart';
import 'package:workout_management/shared/helpers/sqlite_helper.dart';
import 'package:workout_management/shared/utils/appdb.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';

class AddWorkoutPlan extends StatelessWidget {
  AddWorkoutPlan({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showAdaptiveDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text("Workout name"),
            content: Column(
              children: [
                const Text("Enter a name for this workout"),
                SizedBox(
                  height: AppSize.h20,
                ),
                Material(
                    child: SizedBox(
                  height: AppSize.h40,
                  child: CupertinoTextField(
                    controller: controller,
                    placeholder: "New Workout",
                  ),
                ))
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: AppTheme.boldText,
                  )),
              TextButton(
                  onPressed: () async {
                    var id = await SqliteHelper().insertData(Appdb.workout, [
                      {
                        "name": controller.text.isEmpty
                            ? "New workout"
                            : controller.text
                      }
                    ]);
                    context.read<NewWorkoutProvider>().excercies = [];
                    await context
                        .read<WorkoutListProvider>()
                        .getWorkoutPlans()
                        .then(
                      (value) async {
                        await showCupertinoModalBottomSheet(
                          context: context,
                          expand: true,
                          builder: (context) => NewWorkoutSheet(
                            workoutId: id[0],
                          ),
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: const Text("Save")),
            ],
          ),
        );
        context.read<WorkoutListProvider>().getWorkoutPlans();
      },
      child: Container(
        height: AppSize.h50,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSize.r20)),
        child: const Center(
          child: Text(
            "Add Workout Plan +",
            style: AppTheme.boldText,
          ),
        ),
      ),
    );
  }
}
