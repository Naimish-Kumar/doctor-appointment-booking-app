class UserAAppointmentsClass {
  String? success;
  String? register;
  AData? data;

  UserAAppointmentsClass({this.success, this.register, this.data});

  UserAAppointmentsClass.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    register = json['register'];
    data = json['data'] != null ? new AData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['register'] = this.register;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AData {
  int? currentPage;
  List<UAppointmentData>? appointmentData;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<ALinks>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  AData(
      {this.currentPage,
      this.appointmentData,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  AData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      appointmentData = <UAppointmentData>[];
      json['data'].forEach((v) {
        appointmentData!.add(new UAppointmentData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <ALinks>[];
      json['links'].forEach((v) {
        links!.add(new ALinks.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'].toString();
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'].toString();
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.appointmentData != null) {
      data['data'] = this.appointmentData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class UAppointmentData {
  int? id;
  String? date;
  String? slot;
  String? phone;
  String? name;
  String? address;
  String? image;
  String? departmentName;
  String? status;

  UAppointmentData(
      {this.id,
      this.date,
      this.slot,
      this.phone,
      this.name,
      this.address,
      this.image,
      this.departmentName,
      this.status});

  UAppointmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    slot = json['slot'];
    phone = json['phone'].toString();
    name = json['name'];
    address = json['address'];
    image = json['image'];
    departmentName = json['department_name'];
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['slot'] = this.slot;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['address'] = this.address;
    data['image'] = this.image;
    data['department_name'] = this.departmentName;
    data['status'] = this.status;
    return data;
  }
}

class ALinks {
  String? url;
  String? label;
  bool? active;

  ALinks({this.url, this.label, this.active});

  ALinks.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'].toString();
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
