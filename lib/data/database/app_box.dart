import 'package:fitsy/data/entities/recipe_entity.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

class AppBox {
  // The Store of this app.
  late final Store _store;
  late final Box<RecipeEntity> _recipesBox;

  AppBox._create(this._store) {
    _recipesBox = Box<RecipeEntity>(_store);
  }

  // Create an instance of ObjectBox to use throughout the app.
  static Future<AppBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return AppBox._create(store);
  }

  Future<List<RecipeEntity>> getAllMealPlans() => _recipesBox.getAllAsync();

  void replaceAllMealPlans(List<RecipeEntity> plans) async {
    _recipesBox.removeAll();
    _recipesBox.putMany(plans);
  }
}
