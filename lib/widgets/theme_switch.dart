import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/theme.dart';


class ThemeSwitch extends ConsumerStatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  ConsumerState<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends ConsumerState<ThemeSwitch> {
  void toggleTheme(bool value) {
    ref.read(activeThemeProvider.notifier).state =
        value ? Themes.dark : Themes.light;
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      activeColor: Theme.of(context).colorScheme.secondary,
      value: ref.watch(activeThemeProvider) == Themes.dark,
      onChanged: toggleTheme,
    );
  }
}