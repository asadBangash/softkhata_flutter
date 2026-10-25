class CustomerEntriesResponse {
  bool _status;
  List<Entries> _entries;

  CustomerEntriesResponse({bool status, List<Entries> entries}) {
    if (status != null) {
      this._status = status;
    }
    if (entries != null) {
      this._entries = entries;
    }
  }

  bool get status => _status;
  set status(bool status) => _status = status;
  List<Entries> get entries => _entries;
  set entries(List<Entries> entries) => _entries = entries;

  CustomerEntriesResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['entries'] != null) {
      _entries = <Entries>[];
      json['entries'].forEach((v) {
        _entries.add(new Entries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._entries != null) {
      data['entries'] = this._entries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entries {
  String _sId;
  String _userId;
  String _customerId;
  String _description;
  String _balance;
  String _entryType;
  String _time;
  int _iV;

  Entries(
      {String sId,
        String userId,
        String customerId,
        String description,
        String balance,
        String entryType,
        String time,
        int iV}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (customerId != null) {
      this._customerId = customerId;
    }
    if (description != null) {
      this._description = description;
    }
    if (balance != null) {
      this._balance = balance;
    }
    if (entryType != null) {
      this._entryType = entryType;
    }
    if (time != null) {
      this._time = time;
    }
    if (iV != null) {
      this._iV = iV;
    }
  }

  String get sId => _sId;
  set sId(String sId) => _sId = sId;
  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  String get customerId => _customerId;
  set customerId(String customerId) => _customerId = customerId;
  String get description => _description;
  set description(String description) => _description = description;
  String get balance => _balance;
  set balance(String balance) => _balance = balance;
  String get entryType => _entryType;
  set entryType(String entryType) => _entryType = entryType;
  String get time => _time;
  set time(String time) => _time = time;
  int get iV => _iV;
  set iV(int iV) => _iV = iV;

  Entries.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _userId = json['userId'];
    _customerId = json['customerId'];
    _description = json['description'];
    _balance = json['balance'];
    _entryType = json['entryType'];
    _time = json['time'];
    _iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['userId'] = this._userId;
    data['customerId'] = this._customerId;
    data['description'] = this._description;
    data['balance'] = this._balance;
    data['entryType'] = this._entryType;
    data['time'] = this._time;
    data['__v'] = this._iV;
    return data;
  }
}