import 'package:car_seek/core/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../constants/app_routes.dart';

class NavigationWidget {

  static BottomNavigationBar customBottonNavigationBar(BuildContext context, int defaultIndex) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            key: Key(AppRoutes.home),
            label: "Inicio"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            key: Key(AppRoutes.favorites),
            label: "Favoritos"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            key: Key(AppRoutes.sell),
            label: "Vender"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.message),
            key: Key(AppRoutes.chat),
            label: "Chat"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            key: Key(AppRoutes.profile),
            label: "Perfil"
        ),
      ],
      currentIndex: defaultIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            NavigationService.navigateTo(context, AppRoutes.home);
            break;
          case 1:
            NavigationService.navigateTo(context, AppRoutes.favorites);
            break;
          case 2:
            NavigationService.navigateTo(context, AppRoutes.sell);
            break;
          case 3:
            NavigationService.navigateTo(context, AppRoutes.chat);
            break;
          case 4:
            NavigationService.navigateTo(context, AppRoutes.profile);
            break;
        }
      },
    );
  }
}