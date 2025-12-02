// base event class for all HomeBloc actions
abstract class HomeEvent {}

// triggers initial loading of users, favorites, and theme
class FetchUsersEvent extends HomeEvent {}

// event used for searching users by name or email
class SearchUserEvent extends HomeEvent {
  final String query; // search text from user input
  SearchUserEvent(this.query);
}

// toggles favorite status for a specific user
class ToggleFavoriteEvent extends HomeEvent {
  final int userId; // id of the user to add/remove from favorites
  ToggleFavoriteEvent(this.userId);
}

// reloads saved favorite user IDs
class LoadFavoritesEvent extends HomeEvent {}

// fetches latest user list via pull-to-refresh
class RefreshUsersEvent extends HomeEvent {}

// switches between dark and light mode
class ToggleThemeEvent extends HomeEvent {
  final bool isDark; // selected theme mode
  ToggleThemeEvent(this.isDark);
}
