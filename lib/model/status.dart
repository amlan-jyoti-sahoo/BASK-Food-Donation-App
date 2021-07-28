class Status {
  String id;
  String statusState;

  Status({required this.id, required this.statusState});

  static Status fromJson(json) {
    return Status(id: json['id'], statusState: json['statusState']);
  }
}
