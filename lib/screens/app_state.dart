import '/models/user_model.dart';

// Global state management for token, user details, and login state

class AppState {
  static String? _token;
  static UserDetailModel? _userDetail;
  static bool _isLoggedIn = false;

  static String? get token => _token;
  static UserDetailModel? get userDetail => _userDetail;
  static bool get isLoggedIn => _isLoggedIn;

  static void setToken(String token, {UserDetailModel? userDetail}) {
    _token = token;
    _userDetail = userDetail;
    _isLoggedIn = true;

    // You can optionally save to SharedPreferences here for persistence
    // _saveToPreferences();
  }

  static void setUserDetail(UserDetailModel userDetail) {
    _userDetail = userDetail;
  }

  static void logout() {
    _token = null;
    _userDetail = null;
    _isLoggedIn = false;

    // Clear SharedPreferences if used
    // _clearPreferences();
  }
}
