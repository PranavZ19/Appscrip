import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user.dart';

class UserProvider with ChangeNotifier {
  final ApiService apiService;

  UserProvider({required this.apiService});

  List<User> _users = [];
  List<User> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await apiService.fetchUsers();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;
    return _users
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
