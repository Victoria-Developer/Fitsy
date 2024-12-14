import 'package:fitsy/data/entities/meal_plan.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

class AppBox {
  // The Store of this app.
  late final Store _store;
  late final Box<MealPlan> _mealPlans;

  AppBox._create(this._store) {
    _mealPlans = Box<MealPlan>(_store);
  }

  // Create an instance of ObjectBox to use throughout the app.
  static Future<AppBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return AppBox._create(store);
  }

  Future<void> addMealPlan(MealPlan plan) => _mealPlans.putAsync(plan);

  Future<void> removeMealPlan(int id) => _mealPlans.removeAsync(id);

  List<MealPlan> getAllMealPlans() => _mealPlans.getAll();

  void removeAllMealPlans() => _mealPlans.removeAllAsync();

  void addAllMealPlans(List<MealPlan> plans) => _mealPlans.putManyAsync(plans);
}
