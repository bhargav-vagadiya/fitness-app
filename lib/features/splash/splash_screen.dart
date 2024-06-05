import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_management/features/activites/activites_screen.dart';
import 'package:workout_management/shared/provider/common_provider.dart';
import 'package:workout_management/shared/utils/appsizes.dart';
import 'package:workout_management/shared/utils/themes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> loadContents(BuildContext context) async {
    context.read<CommonProvider>().loadExercises().then(
      (value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ActivitesScreen()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadContents(context),
          builder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Workout Manager",
                    style: AppTheme.boldText.copyWith(fontSize: AppSize.sp30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CircularProgressIndicator.adaptive()
                ],
              ),
            );
          }),
    );
  }
}
