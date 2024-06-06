import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/new_workout_provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/workout_list_provider.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/exercise/new_exercise_sheet.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/exercise/reorder_exercise.dart';
import 'package:workout_management/shared/models/exercise_model.dart';
import 'package:workout_management/shared/utils/appdb.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';
import 'package:workout_management/shared/widgets/custom_button.dart';

// ignore: must_be_immutable
class NewWorkoutSheet extends StatelessWidget {
  NewWorkoutSheet({super.key, required this.workoutId});

  final int workoutId;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context
                  .watch<WorkoutListProvider>()
                  .workout
                  .firstWhereOrNull(
                    (element) => element.id == workoutId,
                  )
                  ?.name ??
              ""),
          actions: [
            CupertinoButton(
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                context.read<WorkoutListProvider>().addExcercies(
                    context.read<NewWorkoutProvider>().excercies, workoutId);
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: AppSize.h20, top: AppSize.h20, right: AppSize.h20),
          child: Consumer<NewWorkoutProvider>(
              builder: (context, newWorkoutProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context
                              .watch<WorkoutListProvider>()
                              .workout
                              .firstWhereOrNull(
                                (element) => element.id == workoutId,
                              )
                              ?.name ??
                          "",
                      style: AppTheme.boldText.copyWith(
                        fontSize: AppSize.sp20,
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text("Edit name"),
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
                                        Navigator.pop(context);
                                        await context
                                            .read<WorkoutListProvider>()
                                            .updateWorkout(
                                                Appdb.workout,
                                                [
                                                  {
                                                    "name":
                                                        controller.text.isEmpty
                                                            ? "New workout"
                                                            : controller.text
                                                  }
                                                ],
                                                workoutId);
                                      },
                                      child: const Text("Save")),
                                ],
                              ),
                            );
                            context
                                .read<WorkoutListProvider>()
                                .getWorkoutPlans();
                          },
                        ),
                        PopupMenuItem(
                          child: Text("Reorder exercises"),
                          onTap: () async {
                            await showCupertinoModalBottomSheet(
                              context: context,
                              expand: true,
                              builder: (context) => ReorderExercise(
                                exercises: context
                                    .watch<NewWorkoutProvider>()
                                    .excercies,
                              ),
                            );
                            context
                                .read<NewWorkoutProvider>()
                                .notifyListeners();
                          },
                        ),
                        PopupMenuItem(
                          child: const Text("Delete workout",
                              style: TextStyle(color: Colors.red)),
                          onTap: () async {
                            await context
                                .read<WorkoutListProvider>()
                                .deleteWorkOut(Appdb.workout, "id==$workoutId");
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  newWorkoutProvider.excercies.isEmpty
                      ? "Start by adding an exercise to customise a personal workout plan"
                      : "${newWorkoutProvider.excercies.length} excercies ${newWorkoutProvider.excercies.map(
                            (e) => e.sets?.length ?? 0,
                          ).toList().reduce(
                            (value, element) => value + element,
                          )} sets",
                ),
                SizedBox(
                  height: AppSize.h20,
                ),
                switch (newWorkoutProvider.excercies.isNotEmpty) {
                  true => Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 0),
                                          blurRadius: 15,
                                          color: Colors.grey.withOpacity(0.5))
                                    ],
                                    borderRadius:
                                        BorderRadius.circular(AppSize.r10)),
                                padding: EdgeInsets.all(AppSize.sp10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: AppSize.w240,
                                          child: Text(newWorkoutProvider
                                                  .excercies[index].name ??
                                              ""),
                                        ),
                                        PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: const Text(
                                                  "Delete Exercise",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onTap: () async {
                                                try {
                                                  await newWorkoutProvider
                                                      .deleteExercise(
                                                          newWorkoutProvider
                                                              .excercies[index]
                                                              .id!);
                                                } finally {
                                                  newWorkoutProvider.excercies
                                                      .removeAt(index);
                                                  newWorkoutProvider
                                                      .notifyListeners();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, subIndex) => Row(
                                          children: [
                                            Text("${subIndex + 1}"),
                                            SizedBox(
                                              width: AppSize.w20,
                                            ),
                                            Expanded(
                                                child: CupertinoTextField(
                                              controller: TextEditingController
                                                  .fromValue(TextEditingValue(
                                                      text: (newWorkoutProvider
                                                                  .excercies[
                                                                      index]
                                                                  .sets?[
                                                                      subIndex]
                                                                  .kg ??
                                                              0)
                                                          .toString())),
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  signed: false),
                                              suffix: const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Text("kg"),
                                              ),
                                              onChanged: (value) {
                                                newWorkoutProvider
                                                        .excercies[index]
                                                        .sets?[subIndex]
                                                        .kg =
                                                    int.tryParse(value) ?? 0;
                                                newWorkoutProvider
                                                    .notifyListeners();
                                              },
                                            )),
                                            SizedBox(
                                              width: AppSize.w10,
                                            ),
                                            Expanded(
                                                child: CupertinoTextField(
                                              controller: TextEditingController
                                                  .fromValue(TextEditingValue(
                                                      text: (newWorkoutProvider
                                                                  .excercies[
                                                                      index]
                                                                  .sets?[
                                                                      subIndex]
                                                                  .repos ??
                                                              0)
                                                          .toString())),
                                              onChanged: (value) {
                                                newWorkoutProvider
                                                        .excercies[index]
                                                        .sets?[subIndex]
                                                        .repos =
                                                    int.tryParse(value) ?? 0;
                                                newWorkoutProvider
                                                    .notifyListeners();
                                              },
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  signed: false),
                                              suffix: const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Text("reps"),
                                              ),
                                            )),
                                            IconButton(
                                                onPressed: () {
                                                  newWorkoutProvider
                                                      .excercies[index].sets
                                                      ?.removeAt(subIndex);
                                                  newWorkoutProvider
                                                      .notifyListeners();
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .remove_circle_outline_outlined,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                        itemCount: newWorkoutProvider
                                                .excercies[index]
                                                .sets
                                                ?.length ??
                                            0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSize.h20,
                                    ),
                                    CustomButton(
                                      onTap: () {
                                        newWorkoutProvider.excercies[index].sets
                                            ?.add(Sets());
                                        newWorkoutProvider.notifyListeners();
                                      },
                                      title: "Add set",
                                      foregroundColor: Colors.black,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            itemCount: newWorkoutProvider.excercies.length,
                          ),
                          SizedBox(
                            height: AppSize.h10,
                          ),
                          CustomButton(
                              onTap: () async {
                                var result =
                                    await showCupertinoModalBottomSheet(
                                  context: context,
                                  expand: true,
                                  builder: (context) => NewExerciseSheet(),
                                );
                                if (result is List<ExerciseModel>) {
                                  context.read<NewWorkoutProvider>().excercies =
                                      [
                                    ...context
                                        .read<NewWorkoutProvider>()
                                        .excercies
                                        .map(
                                          (e) => e.copyWith(
                                              reorderNo: context
                                                  .read<NewWorkoutProvider>()
                                                  .excercies
                                                  .indexOf(e)),
                                        ),
                                    ...result.map(
                                      (e) => e.copyWith(
                                          sets: [Sets(kg: 0, repos: 0)]),
                                    )
                                  ];
                                }
                              },
                              title: "Add exercise +"),
                          SizedBox(
                            height: AppSize.h10,
                          ),
                          CustomButton(
                            onTap: () {
                              log("delete");
                              Navigator.pop(context);
                              context.read<WorkoutListProvider>().deleteWorkOut(
                                  Appdb.workout, "id==$workoutId");
                            },
                            title: "Delete Workout",
                            backgroundColor: Colors.deepOrange.withOpacity(0.1),
                            foregroundColor: Colors.deepOrange,
                          ),
                          SizedBox(
                            height: AppSize.h20,
                          ),
                        ],
                      ),
                    ),
                  false => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomButton(
                            onTap: () async {
                              var result = await showCupertinoModalBottomSheet(
                                context: context,
                                expand: true,
                                builder: (context) => NewExerciseSheet(),
                              );
                              if (result is List<ExerciseModel>) {
                                context.read<NewWorkoutProvider>().excercies =
                                    result
                                        .map(
                                          (e) => e.copyWith(
                                              sets: [Sets(kg: 0, repos: 0)]),
                                        )
                                        .toList();
                              }
                            },
                            title: "Add exercise +"),
                        SizedBox(
                          height: AppSize.h10,
                        ),
                        CustomButton(
                          onTap: () {
                            log("delete");
                            Navigator.pop(context);
                            context
                                .read<WorkoutListProvider>()
                                .deleteWorkOut(Appdb.workout, "id==$workoutId");
                          },
                          title: "Delete Workout",
                          backgroundColor: Colors.deepOrange.withOpacity(0.1),
                          foregroundColor: Colors.deepOrange,
                        ),
                      ],
                    )
                },
              ],
            );
          }),
        ));
  }
}
