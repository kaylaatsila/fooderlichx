// ignore_for_file: avoid_returning_null_for_void, unnecessary_null_comparison

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

        // ignore: todo
        // TODO: Create new item
        // 1
        if (groceryManager.isCreatingNewItem)
          GroceryItemScreen.page(onCreate: (item) {
            groceryManager.addItem(item);
          }, onUpdate: (item, index) {
            // No update
          }),

        // ignore: todo
        // TODO: Select GroceryItemScreen
        // 1
        if (groceryManager.selectedIndex != -1)
          // 2
          GroceryItemScreen.page(
              item: groceryManager.selectedGroceryItem,
              index: groceryManager.selectedIndex,
              onUpdate: (item, index) {
                // 3
                groceryManager.updateItem(item, index);
              },
              onCreate: (_) {
                // No create
              }),
        // ignore: todo
        // TODO: Add Profile Screen
        if (profileManager.didSelectUser) ProfileScreen.page(profileManager.getUser),
        // ignore: todo
        // TODO: Add WebView Screen
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
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
    // ignore: todo
    // TODO: Handle state when user closes grocery item screen
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }
    // ignore: todo
    // TODO: Handle state when user closes profile screen
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    // ignore: todo
    // TODO: Handle state when user closes WebView screen
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }
    // 6
    return true;
  }

  // 10
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
