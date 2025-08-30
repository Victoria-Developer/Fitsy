import 'package:flutter/material.dart';

import '../../domain/models/route.dart';

final loadingRoute = NavRoute(path: "/loading", name: "loading");
final errorRoute = NavRoute(path: "/error", name: "error");
final onboardingRoute = NavRoute(path: "/onboarding", name: "onboarding");
final generatorRoute = NavRoute(
    path: "/generator", name: "generator", icon: const Icon(Icons.home));
final settingsRoute = NavRoute(
    path: "/settings", name: "settings", icon: const Icon(Icons.settings));
