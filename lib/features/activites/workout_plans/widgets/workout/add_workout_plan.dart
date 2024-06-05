import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
      onTap: () {
        showAdaptiveDialog(
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
                    Navigator.pop(context);
                    await SqliteHelper().insertData(Appdb.workout, [
                      {
                        "name": controller.text.isEmpty
                            ? "New workout"
                            : controller.text
                      }
                    ]);
                    showCupertinoModalBottomSheet(
                      context: context,
                      expand: true,
                      builder: (context) => NewWorkoutSheet(
                        title: controller.text.isEmpty
                            ? "New workout"
                            : controller.text,
                      ),
                    );
                  },
                  child: const Text("Save")),
            ],
          ),
        );
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
