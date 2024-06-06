import 'package:flutter/material.dart';
import 'package:workout_management/shared/models/exercise_model.dart';

class ReorderExercise extends StatefulWidget {
  const ReorderExercise({super.key, required this.exercises});

  final List<ExerciseModel> exercises;

  @override
  State<ReorderExercise> createState() => _ReorderExerciseState();
}

class _ReorderExerciseState extends State<ReorderExercise> {
  // final List<int> _items = List<int>.generate(50, (int index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reorder Exercise"),
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < widget.exercises.length; index += 1)
            ListTile(
              key: Key('$index'),
              title: Text('${widget.exercises[index].name}'),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final ExerciseModel item = widget.exercises.removeAt(oldIndex);
            widget.exercises
                .insert(newIndex, item.copyWith(reorderNo: newIndex));
          });
        },
      ),
    );
  }
}
