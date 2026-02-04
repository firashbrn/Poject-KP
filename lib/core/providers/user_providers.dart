import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/entities/user.dart';

class UserState {
  final User? currentUser;
  final bool isLoading;

  const UserState({this.currentUser, this.isLoading = false});

  UserState copyWith({User? currentUser, bool? isLoading}) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  void setUser(User user) {
    state = state.copyWith(currentUser: user);
  }

  void clearUser() {
    state = const UserState();
  }


Future<void> logout() async {
    try {
      // 1. Reset state menjadi UserState() (currentUser jadi null, isLoading jadi false)
      clearUser();

      // 2. Hapus token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token'); // Sesuaikan key 'auth_token' dengan milikmu
      
      print("Logout berhasil: State direset dan token dihapus.");
    } catch (e) {
      print("Error saat logout: $e");
      rethrow; 
    }
  }

  bool get isLoggedIn => state.currentUser != null;
}
  

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
