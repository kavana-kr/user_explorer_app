import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_explorer_app/blocs/home/home_state.dart';
import 'package:user_explorer_app/services/shared_pref_service.dart';
import 'package:user_explorer_app/utils/app_colors.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/home/home_event.dart';
import 'utils/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensures async pref calls work

  final isLogged = await PrefService.getLogin(); // load saved login state

  // hide status bar and allow immersive UI
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.bottom],
  );

  // apply custom status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(MyApp(isLogged: isLogged)); // send login state to root widget
}

class MyApp extends StatelessWidget {
  final bool isLogged; // true if user was previously logged in
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // global HomeBloc + initial user fetch event
        BlocProvider(create: (_) => HomeBloc()..add(FetchUsersEvent())),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        // rebuilds MaterialApp whenever theme mode changes
        builder: (context, state) {
          bool isDark =
              state is HomeLoaded ? state.isDark : false; // active theme mode

          return MaterialApp(
            debugShowCheckedModeBanner: false,

            theme: AppThemes.lightTheme,     // full light mode theme
            darkTheme: AppThemes.darkTheme,  // full dark mode theme

            // switch between light/dark based on saved preference
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

            // show login if first time / logged out, else show home
            home: isLogged ? const HomeScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
