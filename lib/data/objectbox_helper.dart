import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/workout.dart';
import '../objectbox.g.dart';
// Will be generated

class ObjectBoxHelper {
  late final Store store;
  late final Box<Workout> workoutBox;

  ObjectBoxHelper._create(this.store) {
    workoutBox = Box<Workout>(store);
  }

  static Future<ObjectBoxHelper> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'objectbox'));
    return ObjectBoxHelper._create(store);
  }
}
