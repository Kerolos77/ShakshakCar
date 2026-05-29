import 'package:go_router/go_router.dart';

import 'app_router.dart';

Future<T?> navigateTo<T>(context, String pageRoute, {Object? extra}) =>
    AppRouter.globalContext.push<T>(pageRoute, extra: extra);

void navigateAndReplacement(context, String pageRoute, {Object? extra}) =>
    AppRouter.globalContext.pushReplacement(pageRoute, extra: extra);

void navigateAndFinish(context, String pageRoute, {Object? extra}) =>
    AppRouter.globalContext.go(pageRoute, extra: extra);

void navigatePop(context) {
  if (AppRouter.globalContext.canPop()) {
    AppRouter.globalContext.pop();
  }
}

bool canPop() {
  return AppRouter.globalContext.canPop();
}
