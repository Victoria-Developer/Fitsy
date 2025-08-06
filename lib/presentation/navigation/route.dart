import 'package:flutter/cupertino.dart';

class NavRoute {
  NavRoute({required this.path, required this.name, this.icon});

  final String path;
  final String name;
  Icon? icon;
}
