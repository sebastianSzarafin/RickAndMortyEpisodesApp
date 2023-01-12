import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_episodes_display/themes/theme.dart';

class RMNavigationDrawer extends StatelessWidget {
  const RMNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: ListView(
            children: const [
              DrawerHeader(
                child: Image(
                  image: AssetImage("assets/images/rick-and-morty-main.png"),
                ),
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.moon_fill,
                  size: 30,
                ),
                title: Text(
                  'Dark mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                trailing: ChangeThemeButtonWidget(),
              ),
            ],
          )),
    );
  }
}

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: ((value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      }),
      activeColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
