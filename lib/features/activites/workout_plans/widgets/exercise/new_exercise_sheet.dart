import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/features/activites/workout_plans/provider/add_exercise_provider.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/exercise/exercise_list_view.dart';
import 'package:workout_management/features/activites/workout_plans/widgets/exercise/sorting_list_view.dart';
import 'package:workout_management/shared/models/exercise_model.dart';
import 'package:workout_management/shared/provider/common_provider.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/widgets/search_textfield.dart';

class NewExerciseSheet extends StatelessWidget {
  NewExerciseSheet({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AddExcerciseProvider(),
        builder: (context, child) {
          var workoutPlanProvider = context.watch<AddExcerciseProvider>();
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              leadingWidth: 85,
              actions: [
                CupertinoButton(
                    onPressed: () {
                      Navigator.pop(
                          context, workoutPlanProvider.selectedExercises);
                    },
                    child: const Text("Add")),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.r20),
              child: Column(
                children: [
                  const Text(
                    "Library",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: AppSize.h10,
                  ),
                  SearchTextField(
                    controller: controller,
                    onChanged: (value) {
                      filterData(context, workoutPlanProvider, value);
                    },
                  ),
                  SizedBox(
                    height: AppSize.h10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            var ids = await showCupertinoModalBottomSheet(
                              context: context,
                              expand: false,
                              builder: (context) => SizedBox(
                                height: ScreenUtil().screenHeight / 1.4,
                                child: SortingListView(
                                  sortType: SortType.muscle,
                                  selected: ValueNotifier(
                                      workoutPlanProvider.selectedmuscles),
                                ),
                              ),
                            );
                            if (ids is List) {
                              workoutPlanProvider.selectedmuscles =
                                  ids as List<String>;
                            }
                            filterData(
                                context, workoutPlanProvider, controller.text);
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.sort,
                                    size: AppSize.sp15,
                                  ),
                                  Text(workoutPlanProvider
                                          .selectedmuscles.isEmpty
                                      ? "All groups"
                                      : "${workoutPlanProvider.selectedmuscles.length}"),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: AppSize.sp15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppSize.w5,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            var ids = await showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: ScreenUtil().screenHeight / 1.4,
                                child: SortingListView(
                                  sortType: SortType.equipment,
                                  selected: ValueNotifier(
                                      workoutPlanProvider.selectedequipments),
                                ),
                              ),
                            );

                            if (ids is List) {
                              var workoutPlanProvider =
                                  context.read<AddExcerciseProvider>();
                              workoutPlanProvider.selectedequipments =
                                  ids as List<String>;
                            }
                            filterData(
                                context, workoutPlanProvider, controller.text);
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.sort,
                                    size: AppSize.sp15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      workoutPlanProvider
                                              .selectedequipments.isEmpty
                                          ? "All equipment"
                                          : "${workoutPlanProvider.selectedequipments.length}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: AppSize.sp15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          workoutPlanProvider.selectedmuscles = [];
                          workoutPlanProvider.selectedequipments = [];
                          filterData(context, workoutPlanProvider, "");
                        },
                      )
                    ],
                  ),
                  Expanded(child: ExerciseListView())
                ],
              ),
            ),
          );
        });
  }

  void filterData(BuildContext context,
      AddExcerciseProvider workoutPlanProvider, String text) {
    var exerciseProvider = context.read<CommonProvider>();

    workoutPlanProvider.filteredExerciseList = [];
    List<ExerciseModel> exercisesByMuscles = [];
    List<ExerciseModel> exercisesByEquipment = [];

    workoutPlanProvider.selectedmuscles.forEach(
      (element) {
        exercisesByMuscles.addAll(exerciseProvider.exercises
            .where(
              (e) =>
                  e.mainMuscles?.firstWhereOrNull((e) => e.id == element) !=
                  null,
            )
            .toList());
      },
    );

    workoutPlanProvider.selectedequipments.forEach(
      (element) {
        exercisesByEquipment.addAll(exerciseProvider.exercises
            .where(
              (e) =>
                  e.equipments?.firstWhereOrNull((e) => e.id == element) !=
                  null,
            )
            .toList());
      },
    );

    var groupedList = [...exercisesByMuscles, ...exercisesByEquipment];
    if (groupedList.isNotEmpty) {
      workoutPlanProvider.filteredExerciseList =
          workoutPlanProvider.fetchAlphabeticalExerciseList(
        groupedList
            .where((element) =>
                element.name!.toLowerCase().contains(text.toLowerCase()))
            .toList(),
      );
    } else {
      workoutPlanProvider.filteredExerciseList =
          workoutPlanProvider.fetchAlphabeticalExerciseList(
        exerciseProvider.exercises
            .where((element) =>
                element.name!.toLowerCase().contains(text.toLowerCase()))
            .toList(),
      );
    }
  }
}
