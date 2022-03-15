import 'package:firebase_crud/state_management/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.mainColor,
          title: Text("Theme "),
          actions: [
            IconButton(
                onPressed: () {
                  _showColor(context);
                },
                icon: Icon(Icons.colorize))
          ],
        ),
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) => Center(
              child: Text(
            "NEVER CHANGE YOUR MIND",
            style: Theme.of(context)
                .textTheme
                .headline2
                ?.copyWith(color: themeProvider.mainColor),
          )),
        ),
      ),
    );
  }

  void _showColor(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              content: Wrap(children: [
                ColorPicker(
                    pickerColor: themeProvider.mainColor,
                    onColorChanged: (color) => themeProvider.changeTheme(color))
              ]),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"))
              ],
            ));
  }
}
