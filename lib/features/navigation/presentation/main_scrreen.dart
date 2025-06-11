import 'package:car_seek/features/chat/presentation/screens/chat_screen.dart';
import 'package:car_seek/features/favorites/presentation/screens/favorite_vehicles_screen.dart';
import 'package:car_seek/features/home/presentation/screens/home_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/profile_screen.dart';
import 'package:car_seek/features/sell/presentation/screens/sell_screen.dart';
import 'package:car_seek/share/domain/entities/conversacion.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final Conversacion? initialConversacion;
  const MainScreen({super.key, this.initialIndex = 0, this.initialConversacion});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _screens = [
      HomeScreen(),
      FavoritesScreen(),
      ChatScreen(conversacion: widget.initialConversacion),
      ProfileScreen(),
    ];
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SellScreen()),
      );
    } else {
      int newIndex = index > 2 ? index - 1 : index;
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex >= 2 ? _selectedIndex + 1 : _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: "Vender"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
