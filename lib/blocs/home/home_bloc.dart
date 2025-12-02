import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/shared_pref_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // stores full user list for search and refresh operations
  List<UserModel> allUsers = [];

  HomeBloc() : super(HomeInitial()) {
    on<FetchUsersEvent>(_fetchUsers);
    on<SearchUserEvent>(_searchUsers);
    on<ToggleFavoriteEvent>(_toggleFavorite);
    on<LoadFavoritesEvent>(_loadFavs);
    on<RefreshUsersEvent>(_refreshUsers);
    on<ToggleThemeEvent>(_toggleTheme);
  }

  // loads users, favorites, and theme when screen opens
  Future<void> _fetchUsers(
    FetchUsersEvent event,
    Emitter<HomeState> emit,
  ) async {
    bool isDark = await PrefService.getTheme(); // get stored theme

    try {
      allUsers = await ApiService.fetchUsers(); // fetch complete users list
      List<int> favs = await PrefService.getFavoriteIds(); // load saved favorites

      emit(HomeLoaded(
        users: allUsers,
        favoriteIds: favs,
        isDark: isDark,
      ));
    } catch (e) {
      emit(HomeError(e.toString(), isDark: isDark));
    }
  }

  // search filter for name and email
  void _searchUsers(SearchUserEvent event, Emitter<HomeState> emit) {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;
    final q = event.query.toLowerCase();

    // filter from original list
    final filtered = allUsers.where((u) {
      return u.name.toLowerCase().contains(q) ||
             u.email.toLowerCase().contains(q);
    }).toList();

    emit(HomeLoaded(
      users: filtered,
      favoriteIds: current.favoriteIds,
      isDark: current.isDark,
      isRefreshing: false,
    ));
  }

  // adds/removes user from favorites
  Future<void> _toggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;

    List<int> favs = List.from(current.favoriteIds); // copy for update

    // toggle logic
    if (favs.contains(event.userId)) {
      favs.remove(event.userId);
    } else {
      favs.add(event.userId);
    }

    await PrefService.saveFavoriteIds(favs); // persist updated favorites

    emit(HomeLoaded(
      users: current.users,
      favoriteIds: favs,
      isDark: current.isDark,
      isRefreshing: false,
    ));
  }

  // reloads favorites & theme when bloc reinitializes
  Future<void> _loadFavs(
    LoadFavoritesEvent event,
    Emitter<HomeState> emit,
  ) async {
    List<int> favs = await PrefService.getFavoriteIds();
    bool isDark = await PrefService.getTheme();

    if (state is HomeLoaded) {
      final current = state as HomeLoaded;

      emit(HomeLoaded(
        users: current.users,
        favoriteIds: favs,
        isDark: current.isDark,
        isRefreshing: false,
      ));
    } else {
      emit(HomeLoaded(
        users: allUsers,
        favoriteIds: favs,
        isDark: isDark,
        isRefreshing: false,
      ));
    }
  }

  // refreshes user list via pull-to-refresh
  Future<void> _refreshUsers(
    RefreshUsersEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;

    // show refresh indicator
    emit(HomeLoaded(
      users: current.users,
      favoriteIds: current.favoriteIds,
      isDark: current.isDark,
      isRefreshing: true,
    ));

    try {
      allUsers = await ApiService.fetchUsers(); // fetch updated list
      List<int> favs = await PrefService.getFavoriteIds(); // reload favorites

      emit(HomeLoaded(
        users: allUsers,
        favoriteIds: favs,
        isDark: current.isDark,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(HomeError(e.toString(), isDark: current.isDark));
    }
  }

  // toggles dark/light mode and saves preference
  Future<void> _toggleTheme(
    ToggleThemeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;

    await PrefService.saveTheme(event.isDark); // persist theme mode

    emit(HomeLoaded(
      users: current.users,
      favoriteIds: current.favoriteIds,
      isDark: event.isDark,
      isRefreshing: false,
    ));
  }
}
