import 'package:flutter/material.dart';
import '../../../sections/NavBar/widget/logo_text.dart';
import 'section_list.dart';

class HomeDrawer extends StatelessWidget {
  final Function(SectionType) onItemSelected;

  const HomeDrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Center(child: LogoText()),
          ),
          ...SectionList.items.map(
                (section) => ListTile(
              title: Text(section.title),
              onTap: () {
                onItemSelected(section.type);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
