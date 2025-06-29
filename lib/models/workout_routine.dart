import 'package:objectbox/objectbox.dart';
import 'workout.dart';

@Entity()
class WorkoutRoutine {
  int id;

  String name;

  @Backlink()
  final workouts = ToMany<Workout>();

  WorkoutRoutine({this.id = 0, required this.name});
}
