import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());
  int selectedDrawerItemIndex = 0;

  bool isWomenOnly = false;

  void changeSelectedDrawerItem(int index) {
    selectedDrawerItemIndex = index;
    emit(ChangeSelectedDrawerItemState());
  }

  Future<void> loadWomenOnlyPreference() async {
    isWomenOnly = CacheHelper.getData(key: 'isWomenOnly') ?? false;
    emit(ChangeSelectedDrawerItemState()); // Re-emit to update UI
  }

  Future<void> toggleWomenOnly(bool value) async {
    isWomenOnly = value;
    await CacheHelper.saveData(key: 'isWomenOnly', value: value);
    emit(ChangeSelectedDrawerItemState());
  }
}
