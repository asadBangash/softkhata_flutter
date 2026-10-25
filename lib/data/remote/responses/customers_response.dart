import 'package:soft_khata_flutter/data/remote/responses/user_model.dart';

class CustomersResponse {
  bool _success;
  CustomerResult _result;

  CustomersResponse.fromJson(Map<String, dynamic> data) {
    _success = data['success'];
    _result = CustomerResult.fromJson(data['result']);
  }

  bool get success => _success;
  CustomerResult get result => _result;
}

class CustomerResult {
  UserModel _user;
  List<CustomerModel> _customers;

  CustomerResult.fromJson(Map<String, dynamic> data) {
    _user = UserModel.fromJson(data['user']);
    _customers = data['customers'].map((customer) {
      CustomerModel.fromJson(customer);
    });
  }

  UserModel get user => _user;
  List<CustomerModel> get customer => _customers;
}

class CustomerModel {
  String _id;
  String _name;
  int _number;
  String _user;
  String _lastEntry;
  String _lastEntryType;

  CustomerModel.fromJson(Map<String, dynamic> data) {
    _id = data['_id'];
    _name = data['name'];
    _number = data['number'];
    _user = data['user'];
    _lastEntry = data['lastEntry'];
    _lastEntryType = data['lastEntryType'];
  }

  String get id => _id;
  String get name => _name;
  String get user => _user;
  int get number => _number;
  String get lastEntry => _lastEntry;
  String get lastEntryType => _lastEntryType;
}