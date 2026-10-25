class GetCustomersResponse {
  bool success;
  GetCustomersResult result;

  GetCustomersResponse({this.success, this.result});

  GetCustomersResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result =
    json['result'] != null ? new GetCustomersResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class GetCustomersResult {
  List<Customers> customers;

  GetCustomersResult({this.customers});

  GetCustomersResult.fromJson(Map<String, dynamic> json) {
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers.add(new Customers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customers != null) {
      data['customers'] = this.customers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customers {
  String lastEntry;
  String lastEntryType;
  String totalBalance;
  String totalExpense;
  String totalIncome;
  String sId;
  String user;
  String name;
  String number;
  String createdAt;
  String updatedAt;
  int iV;

  Customers({
    this.lastEntry,
    this.lastEntryType,
    this.totalBalance,
    this.totalExpense,
    this.totalIncome,
    this.sId,
    this.user,
    this.name,
    this.number,
    this.createdAt,
    this.updatedAt,
    this.iV
  });

  Customers.fromJson(Map<String, dynamic> json) {
    lastEntry = json['lastEntry'];
    lastEntryType = json['lastEntryType'];
    sId = json['_id'];
    user = json['user'];
    name = json['name'];
    number = json['number'];
    totalBalance = json["totalBalance"];
    totalExpense = json["totalExpense"];
    totalIncome = json["totalIncome"];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastEntry'] = this.lastEntry;
    data['lastEntryType'] = this.lastEntryType;
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['name'] = this.name;
    data["totalBalance"] = this.totalBalance;
    data["totalExpense"] = this.totalExpense;
    data["totalIncome"] = this.totalIncome;
    data['number'] = this.number;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}