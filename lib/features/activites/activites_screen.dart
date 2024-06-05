import 'package:flutter/material.dart';
import 'package:workout_management/features/activites/workout_plans/workout_tab.dart';
import 'package:workout_management/shared/utils/appsizes.dart';

class ActivitesScreen extends StatefulWidget {
  const ActivitesScreen({super.key});

  @override
  State<ActivitesScreen> createState() => _ActivitesScreenState();
}

class _ActivitesScreenState extends State<ActivitesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Activites",
          style: TextStyle(fontSize: AppSize.sp20, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  text: "Overview",
                ),
                Tab(
                  text: "Workout Plans",
                )
              ],
              tabAlignment: TabAlignment.start,
              isScrollable: true,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(AppSize.sp10),
              child: TabBarView(children: [
                Container(),
                const WorkoutTab(),
              ]),
            ))
          ],
        ),
      ),
    );
  }
}
