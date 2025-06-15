import '../data/menu_data.dart';
import '../models/menu_item.dart';

class DataService {
  // Get all menu items (load from storage if available, otherwise use default data)
  static Future<List<MenuItem>> getMenuItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return menuData;
  }
}
