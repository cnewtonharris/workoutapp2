import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../theme/app_styles.dart';


class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutProvider);

    final nameController = TextEditingController();
    final weightController = TextEditingController();
    final repsController = TextEditingController();
    final setsController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Build Your Workout'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              padding: AppStyles.screenPadding,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Add Exercise',
                      style: AppStyles.header,
                    ),
                    const SizedBox(height: 10),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Exercise Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: repsController,
                  decoration: const InputDecoration(labelText: 'Reps'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: setsController,
                  decoration: const InputDecoration(labelText: 'Sets'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Workout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    final workout = Workout(
                      exerciseName: nameController.text,
                      weight: double.tryParse(weightController.text) ?? 0,
                      reps: int.tryParse(repsController.text) ?? 0,
                      sets: int.tryParse(setsController.text) ?? 0,
                    );
                    ref.read(workoutProvider.notifier).addWorkout(workout);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Workout added')),
                    );

                    nameController.clear();
                    weightController.clear();
                    repsController.clear();
                    setsController.clear();
                  },
                ),

                const SizedBox(height: 24),
                    const Text(
                      'Workout Log',
                      style: AppStyles.header,
                    ),
                    const SizedBox(height: 10),

                if (workouts.isEmpty) ...[
                  const Center(child: Text('No workouts yet.')),
                ] else ...[
                  ...workouts.map((w) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text('${w.exerciseName} - ${w.weight}kg'),
                      subtitle: Text('${w.sets} sets x ${w.reps}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => ref.read(workoutProvider.notifier).deleteWorkout(w.id),
                      ),
                    ),
                  )).toList(),
                ],
              ],
            ),
          ),
        ),
      );
    }
}