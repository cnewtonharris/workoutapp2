import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutapp2/screens/routine_detail_screen.dart';
import '../models/workout_routine.dart';
import '../data/objectbox_helper.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // for Clipboard


class RoutinesScreen extends ConsumerStatefulWidget {
  const RoutinesScreen({super.key});

  @override
  ConsumerState<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends ConsumerState<RoutinesScreen> {
  final _routineNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final db = ref.read(objectBoxProvider);
    final routines = db.store.box<WorkoutRoutine>().getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('My Routines')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _routineNameController,
              decoration: const InputDecoration(labelText: 'Routine Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final newRoutine = WorkoutRoutine(name: _routineNameController.text);
                db.store.box<WorkoutRoutine>().put(newRoutine);
                _routineNameController.clear();
                setState(() {}); // refresh list
              },
              child: const Text('Add Routine'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return ListTile(
                    title: Text(routine.name),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'duplicate') {
                          final newRoutine = WorkoutRoutine(name: '${routine.name} Copy');
                          db.store.box<WorkoutRoutine>().put(newRoutine);

                          for (var w in routine.workouts) {
                            final newWorkout = Workout(
                              exerciseName: w.exerciseName,
                              weight: w.weight,
                              reps: w.reps,
                              sets: w.sets,
                            );
                            final workoutId = db.workoutBox.put(newWorkout);
                            final savedWorkout = db.workoutBox.get(workoutId)!;
                            savedWorkout.routine.target = newRoutine;
                            db.workoutBox.put(savedWorkout);

                          }

                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${routine.name} duplicated')),
                          );
                        }

                        if (value == 'rename') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final controller = TextEditingController(text: routine.name);
                              return AlertDialog(
                                title: const Text('Rename Routine'),
                                content: TextField(controller: controller),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      routine.name = controller.text;
                                      db.store.box<WorkoutRoutine>().put(routine);
                                      Navigator.pop(context);
                                      setState(() {});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Routine renamed')),
                                      );
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (value == 'export') {
                          final exportMap = {
                            'name': routine.name,
                            'workouts': routine.workouts.map((w) => {
                              'exercise': w.exerciseName,
                              'weight': w.weight,
                              'reps': w.reps,
                              'sets': w.sets,
                            }).toList(),
                          };

                          final jsonString = jsonEncode(exportMap);

                          // Copy to clipboard
                          Clipboard.setData(ClipboardData(text: jsonString));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Routine copied as JSON')),
                          );
                        }

                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'rename', child: Text('Rename')),
                        const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                        const PopupMenuItem(value: 'export', child: Text('Export to JSON')),

                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoutineDetailScreen(routineId: routine.id),
                        ),
                      );
                    },
                  );

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
