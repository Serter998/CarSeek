import 'package:flutter/material.dart';

class NavigationService {
  static Future<void> navigateTo(
      BuildContext context, String routeName) async {
    await Navigator.pushNamed(context, routeName);
  }

  static Future<void> navigateToReplacement(
      BuildContext context, String routeName) async {
    await Navigator.pushReplacementNamed(context, routeName);
  }

  static Future<void> navigateToWidget(
      BuildContext context,
      Widget page,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<void> navigateToWidgetReplacement(
      BuildContext context,
      Widget page,
      ) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}