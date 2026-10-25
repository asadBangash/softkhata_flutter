class AddCustomerResponse {
  bool success;
  AddCustomerResult result;

  AddCustomerResponse({this.success, this.result});

  AddCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result =
    json['result'] != null ? new AddCustomerResult.fromJson(json['result']) : null;
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

class AddCustomerResult {
  String message;
  Customer customer;

  AddCustomerResult({this.message, this.customer});

  AddCustomerResult.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  String lastEntry;
  String lastEntryType;
  String sId;
  String user;
  String name;
  String number;
  String createdAt;
  String updatedAt;
  int iV;

  Customer(
      {this.lastEntry,
        this.lastEntryType,
        this.sId,
        this.user,
        this.name,
        this.number,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Customer.fromJson(Map<String, dynamic> json) {
    lastEntry = json['lastEntry'];
    lastEntryType = json['lastEntryType'];
    sId = json['_id'];
    user = json['user'];
    name = json['name'];
    number = json['number'];
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
    data['number'] = this.number;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}