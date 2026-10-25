class GetEntriesResponse {
  bool status;
  List<Entries> entries;

  GetEntriesResponse({this.status, this.entries});

  GetEntriesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['entries'] != null) {
      entries = <Entries>[];
      json['entries'].forEach((v) {
        entries.add(new Entries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.entries != null) {
      data['entries'] = this.entries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entries {
  String sId;
  String userId;
  String customerId;
  String description;
  String balance;
  String entryType;
  String time;
  int iV;

  Entries({
    this.sId,
    this.userId,
    this.customerId,
    this.description,
    this.balance,
    this.entryType,
    this.time,
    this.iV,
  });

  Entries.fromJson(Map<String, dynamic> json) {
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