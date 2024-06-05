import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/new_workout_provider.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/exercise/new_exercise_sheet.dart';
import 'package:workout_management/shared/models/exercise_model.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';
import 'package:workout_management/shared/widgets/custom_button.dart';

class NewWorkoutSheet extends StatelessWidget {
  const NewWorkoutSheet({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewWorkoutProvider(),
        builder: (context, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(title),
                actions: [
                  CupertinoButton(
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {},
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
                            title,
                            style: AppTheme.boldText.copyWith(
                              fontSize: AppSize.sp20,
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text("Edit name"),
                                onTap: () {},
                              ),
                              PopupMenuItem(
                                child: const Text("Reorder exercises"),
                                onTap: () {},
                              ),
                              PopupMenuItem(
                                child: const Text("Delete workout",
                                    style: TextStyle(color: Colors.red)),
                                onTap: () {},
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
                                                color: Colors.grey
                                                    .withOpacity(0.5))
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              AppSize.r10)),
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
                                                        .excercies[index]
                                                        .name ??
                                                    ""),
                                              ),
                                              PopupMenuButton(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    child: const Text(
                                                        "Delete Exercise",
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    onTap: () {
                                                      newWorkoutProvider
                                                          .excercies
                                                          .removeAt(index);
                                                      newWorkoutProvider
                                                          .notifyListeners();
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
                                              itemBuilder:
                                                  (context, subIndex) => Row(
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
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                            signed: false),
                                                    suffix: const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Text("kg"),
                                                    ),
                                                    onChanged: (value) {
                                                      newWorkoutProvider
                                                              .excercies[index]
                                                              .sets?[subIndex]
                                                              .kg =
                                                          int.tryParse(value) ??
                                                              0;
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
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                            signed: false),
                                                    suffix: const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Text("reps"),
                                                    ),
                                                  )),
                                                  IconButton(
                                                      onPressed: () {
                                                        newWorkoutProvider
                                                            .excercies[index]
                                                            .sets
                                                            ?.removeAt(
                                                                subIndex);
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
                                              newWorkoutProvider
                                                  .excercies[index].sets
                                                  ?.add(Sets());
                                              newWorkoutProvider
                                                  .notifyListeners();
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
                                  itemCount:
                                      newWorkoutProvider.excercies.length,
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
                                        builder: (context) =>
                                            NewExerciseSheet(),
                                      );
                                      if (result is List<ExerciseModel>) {
                                        context
                                            .read<NewWorkoutProvider>()
                                            .excercies = [
                                          ...context
                                              .read<NewWorkoutProvider>()
                                              .excercies,
                                          ...result
                                              .map(
                                                (e) => e.copyWith(sets: [
                                                  Sets(kg: 0, repos: 0)
                                                ]),
                                              )
                                              .toList()
                                        ];
                                      }
                                    },
                                    title: "Add exercise +"),
                                SizedBox(
                                  height: AppSize.h10,
                                ),
                                CustomButton(
                                  onTap: () {},
                                  title: "Delete Workout",
                                  backgroundColor:
                                      Colors.deepOrange.withOpacity(0.1),
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
                                    var result =
                                        await showCupertinoModalBottomSheet(
                                      context: context,
                                      expand: true,
                                      builder: (context) => NewExerciseSheet(),
                                    );
                                    if (result is List<ExerciseModel>) {
                                      context.read<NewWorkoutProvider>().excercies =
                                          result
                                              .map(
                                                (e) => e.copyWith(sets: [
                                                  Sets(kg: 0, repos: 0)
                                                ]),
                                              )
                                              .toList();
                                    }
                                  },
                                  title: "Add exercise +"),
                              SizedBox(
                                height: AppSize.h10,
                              ),
                              CustomButton(
                                onTap: () {},
                                title: "Delete Workout",
                                backgroundColor:
                                    Colors.deepOrange.withOpacity(0.1),
                                foregroundColor: Colors.deepOrange,
                              ),
                            ],
                          )
                      },
                    ],
                  );
                }),
              ));
        });
  }
}
