import 'package:firebase_crud/state_management/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) => ThemePage()));
  }
}
