class UserModel {
  String _id;
  String _name;
  String _email;
  int _number;
  String _businessName;
  String _businessCategory;

  UserModel.fromJson(Map<String, dynamic> data) {
    _id = data['_id'];
    _name = data['name'];
    _email = data['email'];
    _number = data['number'];
    _businessName = data['businessName'];
    _businessCategory = data['businessCategory'];
  }

  String get id => _id;
  String get name => _name;
  String get email => _email;
  int get number => _number;
  String get businessName => _businessName;
  String get businessCat => _businessCategory;
}
