import 'package:flutter/material.dart';

import '../fragment/fragment_dirasakan.dart';
import '../fragment/fragment_magnitudo.dart';
import '../fragment/fragment_terkini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  final List _pages = [
    const FragmentTerkini(),
    const FragmentMagnitudo(),
    const FragmentDirasakan(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Info Gempa',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
      body: _pages[_selectedTab],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30)
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: 0,
                blurRadius: 10
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0)
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedTab,
            onTap: (index) => _changeTab(index),
            selectedFontSize: 12,
            unselectedItemColor: Colors.black26,
            selectedItemColor: Colors.lightBlue,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.restart_alt), label: "Terkini"),
              BottomNavigationBarItem(icon: Icon(Icons.read_more_sharp), label: "M ≥ 5"),
              BottomNavigationBarItem(icon: Icon(Icons.query_stats_sharp), label: "Dirasakan"),
            ],
          ),
        ),
      ),
    );
  }
}
