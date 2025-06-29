import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../data/objectbox_helper.dart';

class WorkoutNotifier extends StateNotifier<List<Workout>> {
  final ObjectBoxHelper db;

  WorkoutNotifier(this.db) : super([]) {
    loadWorkouts(); // load initial data
  }

  void loadWorkouts() {
    final workouts = db.workoutBox.getAll();
    state = workouts;
  }

  void addWorkout(Workout workout) {
    db.workoutBox.put(workout);
    loadWorkouts(); // refresh the list
  }

  void deleteWorkout(int id) {
    db.workoutBox.remove(id);
    loadWorkouts();
  }
}

final objectBoxProvider = Provider<ObjectBoxHelper>((ref) {
  throw UnimplementedError('ObjectBox must be initialized first');
});

final workoutProvider = StateNotifierProvider<WorkoutNotifier, List<Workout>>((ref) {
  final db = ref.watch(objectBoxProvider);
  return WorkoutNotifier(db);
});
