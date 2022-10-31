// ignore_for_file: avoid_returning_null_for_void

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/screens.dart';

// 1
class AppRouter extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  // 2
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  // 3
  final AppStateManager appStateManager;
  // 4
  final GroceryManager groceryManager;
  // 5
  final ProfileManager profileManager;
  AppRouter({required this.appStateManager, required this.groceryManager, required this.profileManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    // ignore: todo
    // TODO: Add Listeners
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }
  // ignore: todo
  // TODO: Dispose listeners
  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  // 6
  @override
  Widget build(BuildContext context) {
    // 7
    return Navigator(
      // 8
      key: navigatorKey,
      // ignore: todo
      // TODO: Add onPopPage
      onPopPage: _handlePopPage,
      // 9
      pages: [
        // ignore: todo
        // TODO: Add SplashScreen
        if (!appStateManager.isInitialized) SplashScreen.page(),
        // ignore: todo
        // TODO: Add LoginScreen
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn) LoginScreen.page(),
        // ignore: todo
        // TODO: Add OnboardingScreen
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete) OnboardingScreen.page(),
        // ignore: todo
        // TODO: Add Home
        if (appStateManager.isOnboardingComplete) Home.page(appStateManager.getSelectedTab),
        // TODO: Create new item
        // TODO: Select GroceryItemScreen
        // TODO: Add Profile Screen
        // TODO: Add WebView Screen
      ],
    );
  }

  // ignore: todo
  // TODO: Add _handlePopPage
  bool _handlePopPage(
      // 1
      Route<dynamic> route,
      // 2
      result) {
    // 3
    if (!route.didPop(result)) {
      // 4
      return false;
    }
    // 5
    // ignore: todo
    // TODO: Handle Onboarding and splash
    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }
    // TODO: Handle state when user closes grocery item screen
    // TODO: Handle state when user closes profile screen
    // TODO: Handle state when user closes WebView screen
    // 6
    return true;
  }

  // 10
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
