import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_episodes_display/themes/theme.dart';

class RMBottomNavigationBar extends StatefulWidget {
  const RMBottomNavigationBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  State<RMBottomNavigationBar> createState() => _RMBottomNavigationBarState();
}

class _RMBottomNavigationBarState extends State<RMBottomNavigationBar> {
  var selectedIndex = 1;
  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RMNavigationBarItem(
                index: 0,
                label: 'Characters',
                icon: CupertinoIcons.group_solid,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              RMNavigationBarItem(
                index: 1,
                label: 'Episodes',
                icon: CupertinoIcons.film_fill,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
              RMNavigationBarItem(
                index: 2,
                label: 'Locations',
                icon: CupertinoIcons.compass_fill,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RMNavigationBarItem extends StatelessWidget {
  const RMNavigationBarItem({
    super.key,
    required this.index,
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 25,
              color: isSelected ? AppColors.currentScreen : null,
            ),
            Text(
              label,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.currentScreen)
                  : const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
