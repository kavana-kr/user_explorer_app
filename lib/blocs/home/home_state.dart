import 'package:user_explorer_app/models/user_model.dart';

// base state class for HomeBloc
abstract class HomeState {}

// initial state before any data is loaded
class HomeInitial extends HomeState {}

// loading state used while fetching users
class HomeLoading extends HomeState {
  final bool isDark; // maintain theme even during loading
  HomeLoading({required this.isDark});
}

// main state containing all UI data
class HomeLoaded extends HomeState {
  final List<UserModel> users; // list of users displayed on screen
  final List<int> favoriteIds; // IDs of users marked as favorite
  final bool isDark; // current theme mode
  final bool isRefreshing; // flag to show pull-to-refresh indicator

  HomeLoaded({
    required this.users,
    required this.favoriteIds,
    required this.isDark,
    this.isRefreshing = false, // default: not refreshing
  });
}

// state shown when API or loading fails
class HomeError extends HomeState {
  final String message; // error message to display
  final bool isDark; // maintain theme on error screen

  HomeError(this.message, {required this.isDark});
}
