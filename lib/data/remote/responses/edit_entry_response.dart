class EditEntryResponse {
  bool success;
  String message;
  Entry entry;

  EditEntryResponse({this.success, this.message, this.entry});

  EditEntryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    entry = json['entry'] != null ? new Entry.fromJson(json['entry']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.entry != null) {
      data['entry'] = this.entry.toJson();
    }
    return data;
  }
}

class Entry {
  String sId;
  String userId;
  String customerId;
  String description;
  String balance;
  String entryType;
  String time;
  int iV;

  Entry({
    this.sId,
    this.userId,
    this.customerId,
    this.description,
    this.balance,
    this.entryType,
    this.time,
    this.iV
  });

  Entry.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    customerId = json['customerId'];
    description = json['description'];
    balance = json['balance'];
    entryType = json['entryType'];
    time = json['time'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['customerId'] = this.customerId;
    data['description'] = this.description;
    data['balance'] = this.balance;
    data['entryType'] = this.entryType;
    data['time'] = this.time;
    data['__v'] = this.iV;
    return data;
  }
}