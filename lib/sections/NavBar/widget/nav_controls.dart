import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../ThemeCubit/theme_cubit.dart';

class NavControls extends StatelessWidget {
  const NavControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            final isDark = themeMode == ThemeMode.dark;

            return IconButton(
              icon: FaIcon(
                isDark
                    ? FontAwesomeIcons.solidSun   
                    : FontAwesomeIcons.solidMoon,
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme(); 
              },
            );
          },
        ),
      ],
    );
  }
}
