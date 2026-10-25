class SignupResponse {
  bool _success;
  SignupResult _result;

  SignupResponse.fromJson(Map<String, dynamic> data) {
    _success = data['success'];
    _result = SignupResult.fromJson(data['result']);
  }

  bool get success => _success;
  SignupResult get result => _result;
}

class SignupResult {
  String _message;

  SignupResult.fromJson(Map<String, dynamic> data) {
    _message = data['message'];
  }

  String get message => _message;
}
