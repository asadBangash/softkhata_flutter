class EditCustomerResponse {
  bool success;
  String message;
  Customer customer;

  EditCustomerResponse({this.success, this.message, this.customer});

  EditCustomerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
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