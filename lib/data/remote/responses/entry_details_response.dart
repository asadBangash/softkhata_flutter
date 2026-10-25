class EntryDetailsResponse {
  bool status;
  Data data;

  EntryDetailsResponse({this.status, this.data});

  EntryDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String sId;
  String userId;
  String customerId;
  String description;
  String balance;
  String entryType;
  String time;

  Data(
      {this.sId,
        this.userId,
        this.customerId,
        this.description,
        this.balance,
        this.entryType,
        this.time});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    customerId = json['customerId'];
    description = json['description'];
    balance = json['balance'];
    entryType = json['entryType'];
    time = json['time'];
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
    return data;
  }
}