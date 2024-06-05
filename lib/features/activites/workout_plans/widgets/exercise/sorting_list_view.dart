import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/shared/provider/common_provider.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';
import 'package:workout_management/shared/widgets/custom_button.dart';

enum SortType { muscle, equipment, none }

class SortingListView extends StatelessWidget {
  SortingListView({super.key, required this.sortType, required this.selected});

  final SortType sortType;

  final ValueNotifier<List<String>> selected;
  final ValueNotifier<List<dynamic>> list = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CommonProvider>();

    list.value =
        sortType == SortType.muscle ? provider.muscles : provider.equipments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Filter by ${sortType == SortType.muscle ? "muscle group" : "equipment"}",
          style: AppTheme.boldText.copyWith(fontSize: AppSize.sp15),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: list,
        builder: (context, primaryList, child) => ValueListenableBuilder(
          valueListenable: selected,
          builder: (context, value, child) => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    bool itemContains = value.contains(primaryList[index].id);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile.adaptive(
                        tileColor: itemContains
                            ? Colors.deepOrange.withOpacity(0.1)
                            : null,
                        activeColor: Colors.deepOrange,
                        shape: itemContains
                            ? RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.r20),
                                side:
                                    const BorderSide(color: Colors.deepOrange))
                            : null,
                        value: itemContains,
                        onChanged: (result) {
                          bool itemContains =
                              value.contains(primaryList[index].id);
                          if (itemContains) {
                            selected.value.remove(primaryList[index].id);
                          } else {
                            selected.value.add(primaryList[index].id);
                          }
                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          selected.notifyListeners();
                        },
                        title: Text(primaryList[index].name ?? ""),
                      ),
                    );
                  },
                  itemCount: primaryList.length,
                ),
              ),
              CustomButton(
                  onTap: () {
                    Navigator.pop(context, value);
                  },
                  title: "Filter"),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
