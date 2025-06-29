import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutapp2/models/workout_routine.dart';
import '../models/workout.dart';
import '../data/objectbox_helper.dart';
import '../providers/workout_provider.dart';

int calculateVolume(List<Workout> workouts) {
  int volume = 0;
  for (var w in workouts) {
    volume += (w.weight * w.reps * w.sets).toInt();
  }
  return volume;
}


class RoutineDetailScreen extends ConsumerStatefulWidget {
  final int routineId;

  const RoutineDetailScreen({super.key, required this.routineId});

  @override
  ConsumerState<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends ConsumerState<RoutineDetailScreen> {
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final db = ref.read(objectBoxProvider);
    final routineBox = db.store.box<WorkoutRoutine>();
    final routine = routineBox.get(widget.routineId)!;

    final workouts = routine.workouts;

    final volume = calculateVolume(workouts as List<Workout>);


    return Scaffold(
      appBar: AppBar(title: Text(routine.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Exercise')),
            const SizedBox(height: 6),
            TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Weight'), keyboardType: TextInputType.number),
            const SizedBox(height: 6),
            TextField(controller: repsController, decoration: const InputDecoration(labelText: 'Reps'), keyboardType: TextInputType.number),
            const SizedBox(height: 6),
            TextField(controller: setsController, decoration: const InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Add to Routine'),
              onPressed: () {
                final workout = Workout(
                  exerciseName: nameController.text,
                  weight: double.tryParse(weightController.text) ?? 0,
                  reps: int.tryParse(repsController.text) ?? 0,
                  sets: int.tryParse(setsController.text) ?? 0,
                );

                // Put workout into box first to get an ID
                final workoutId = db.workoutBox.put(workout);

                // Assign the routine relationship
                final updatedWorkout = db.workoutBox.get(workoutId)!;
                updatedWorkout.routine.target = routine as WorkoutRoutine?; // safer assignment
                db.workoutBox.put(updatedWorkout);

                // Clear form fields
                nameController.clear();
                weightController.clear();
                repsController.clear();
                setsController.clear();

                // Refresh UI
                setState(() {});

                // Show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${workout.exerciseName} added to ${routine.name}')),
                );
              },
            ),
            const Divider(height: 32),

            Text(
              'Total Volume: $volume kg',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: workouts.map((w) {
                  return Card(
                    child: ListTile(
                      title: Text(w.exerciseName),
                      subtitle: Text('${w.sets}×${w.reps} at ${w.weight}kg'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          db.workoutBox.remove(w.id); // remove the workout
                          setState(() {}); // refresh UI
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${w.exerciseName} removed')),
                          );
                        },
                      ),

                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
