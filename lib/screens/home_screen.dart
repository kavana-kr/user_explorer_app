import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_explorer_app/utils/app_colors.dart';
import 'package:user_explorer_app/utils/app_constants.dart';
import 'package:user_explorer_app/utils/app_themes.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../services/shared_pref_service.dart';
import '../widgets/user_card.dart';
import '../widgets/search_bar.dart';
import 'login_screen.dart';
import 'user_detail_screen.dart';

// used to animate shimmer effect by sliding gradient
class SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _currentTheme = false; // holds current theme locally
  bool showShimmer = true; // controls shimmer during initial load

  final TextEditingController searchController = TextEditingController(); // search field controller

  @override
  void initState() {
    super.initState();
    _loadInitialTheme(); // load saved theme on screen open
    _startShimmerTimer(); // short shimmer animation for UI
  }

  // small delay to show shimmer for smooth animation
  void _startShimmerTimer() {
    showShimmer = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => showShimmer = false);
    });
  }

  // load previously saved theme from shared preferences
  Future<void> _loadInitialTheme() async {
    final isDark = await PrefService.getTheme();
    if (mounted) setState(() => _currentTheme = isDark);
  }

  // shimmer placeholder for user card
  Widget _shimmerUserCard(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1, end: 2),
      duration: const Duration(milliseconds: 1300),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.16),
                Colors.transparent,
              ],
              stops: const [0.3, 0.5, 0.7],
              transform: SlidingGradientTransform(value),
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context); // accessing bloc

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // update theme when state changes
        if (state is HomeLoaded || state is HomeError || state is HomeLoading) {
          _currentTheme = (state as dynamic).isDark;
        }
      },
      builder: (context, state) {
        bool isDark = _currentTheme; // theme to apply on UI

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,

          // ---------------- APP BAR ---------------- //
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: isDark ? AppColors.textLight : Colors.black,
            ),
            title: Text(
              AppConstants.employee,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : Colors.black,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppThemes.loginDarkGradient
                    : AppThemes.loginLightGradient,
              ),
            ),
          ),

          // ---------------- DRAWER ---------------- //
          drawer: Drawer(
            backgroundColor:
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? AppThemes.loginDarkGradient
                        : AppThemes.loginLightGradient,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      AppConstants.appName,
                      style: TextStyle(
                        color: isDark ? AppColors.textLight : Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // theme toggle switch
                SwitchListTile(
                  title: Text(
                    AppConstants.darkMode,
                    style: TextStyle(
                      color: isDark ? AppColors.textLight : Colors.black,
                    ),
                  ),
                  value: isDark,
                  onChanged: (value) {
                    context.read<HomeBloc>().add(ToggleThemeEvent(value));
                  },
                ),

                const Divider(),

                // logout button
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                  title: Text(
                    AppConstants.logOut,
                    style: TextStyle(
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  onTap: () {
                    // logout confirmation dialog
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => Dialog(
                        elevation: 8,
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _logoutDialog(isDark),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ---------------- BODY ---------------- //
          body: Column(
            children: [
              // search bar with fade-in animation
              Padding(
                padding: const EdgeInsets.all(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 450),
                  builder: (context, v, child) =>
                      Opacity(opacity: v, child: child),
                  child: MySearchBar(
                    isDark: isDark,
                    controller: searchController,

                    onChanged: (value) {
                      if (value.isEmpty) {
                        _startShimmerTimer(); // show shimmer again
                        homeBloc.add(RefreshUsersEvent()); // reload users
                      } else {
                        homeBloc.add(SearchUserEvent(value)); // filter users
                      }
                    },
                  ),
                ),
              ),

              // list of users + pull to refresh
              Expanded(
                child: RefreshIndicator(
                  color: isDark ? AppColors.accent : AppColors.primary,
                  onRefresh: () async {
                    searchController.clear(); // reset search

                    homeBloc.add(SearchUserEvent("")); // reset filter
                    _startShimmerTimer();
                    homeBloc.add(RefreshUsersEvent()); // fetch latest

                    await Future.delayed(const Duration(milliseconds: 100));
                  },
                  child: _buildBody(state, isDark, homeBloc), // build list
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // logout popup UI extracted
  Widget _logoutDialog(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkSurface : AppColors.lightSurface)
            .withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppConstants.logOut,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              fontSize: 20,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            AppConstants.logOutMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.4,
              fontSize: 15.5,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              // cancel button
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppThemes.buttonGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      AppConstants.cancel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // final logout button
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppThemes.buttonGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(1.5),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await PrefService.clearFavorites();
                        await PrefService.removeLogin();

                        context.read<HomeBloc>().add(LoadFavoritesEvent());

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Text(
                        AppConstants.logOut,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonGradientStart,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // builds user list or shimmer or loader based on state
  Widget _buildBody(HomeState state, bool isDark, HomeBloc homeBloc) {
    if (showShimmer) {
      // display shimmer placeholders
      return ListView.builder(
        itemCount: 7,
        itemBuilder: (context, i) => _shimmerUserCard(isDark),
      );
    }

    if (state is! HomeLoaded) {
      // fallback empty space
      return ListView(children: const [SizedBox(height: 200)]);
    }

    if (state.isRefreshing) {
      // refresh loader
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.accent : AppColors.primary,
        ),
      );
    }

    final users = state.users; // loaded users
    final favorites = state.favoriteIds; // favorite IDs

    // main list builder
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final u = users[index];
        final isFav = favorites.contains(u.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 350 + index * 80),
            builder: (c, v, child) => Transform.translate(
              offset: Offset(0, 30 * (1 - v)),
              child: Opacity(opacity: v, child: child),
            ),
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailScreen(user: u),
                  ),
                );
                _startShimmerTimer(); // shimmer again after returning
              },
              child: Hero(
                tag: "user_${u.id}", // hero animation tag
                child: Material(
                  color: Colors.transparent,
                  child: UserCard(
                    user: u,
                    isFavorite: isFav,
                    isDark: isDark,
                    onFavoriteTap: () {
                      homeBloc.add(ToggleFavoriteEvent(u.id)); // toggle fav
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
