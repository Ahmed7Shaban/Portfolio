import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:website/screans/home_responsive.dart';

import 'ThemeCubit/theme_cubit.dart';
import 'core/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return AnimatedTheme(
          data: AppTheme.getThemeData(themeMode),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInCubic,
          child: MaterialApp(
            title: 'Ahmed Shaban',
            themeMode: themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            debugShowCheckedModeBanner: false,
            home: const HomeResponsive(),
          ),
        );
      },
    );
  }
}
