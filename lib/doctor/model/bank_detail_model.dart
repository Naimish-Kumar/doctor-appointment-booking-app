class UpdateBankDetails {
  int? status;
  String? msg;
  int? success;

  UpdateBankDetails({this.status, this.msg, this.success});

  UpdateBankDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['success'] = this.success;
    return data;
  }
}

class GetBankDetails {
  int? status;
  String? msg;
  int? success;
  BankData? data;

  GetBankDetails({this.status, this.msg, this.success, this.data});

  GetBankDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    success = json['success'];
    data = json['data'] != null ? new BankData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BankData {
  dynamic bankName;
  dynamic ifscCode;
  dynamic accountNo;
  dynamic accountHolderName;

  BankData(
      {this.bankName, this.ifscCode, this.accountNo, this.accountHolderName});

  BankData.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    accountNo = json['account_no'];
    accountHolderName = json['account_holder_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_name'] = this.bankName;
    data['ifsc_code'] = this.ifscCode;
    data['account_no'] = this.accountNo;
    data['account_holder_name'] = this.accountHolderName;
    return data;
  }
}
