import 'package:objectbox/objectbox.dart';
import 'workout_routine.dart';

@Entity()
class Workout {
  int id;
  String exerciseName;
  double weight;
  int reps;
  int sets;

  final routine = ToOne<WorkoutRoutine>(); // this must be exactly like this

  Workout({
    this.id = 0,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
  });
}
