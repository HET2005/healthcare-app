class UserDatabase {
  static final Map<String, String> _users = {};

  static bool login(String id, String password) {
    return _users.containsKey(id) && _users[id] == password;
  }

  static bool userExists(String id) {
    return _users.containsKey(id);
  }

  static void register(String id, String password) {
    _users[id] = password;
  }
}
