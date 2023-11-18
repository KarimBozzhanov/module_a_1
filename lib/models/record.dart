class Record {
  Record({required this.name, required this.path});

  final String name;
  final String path;

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(name: json["name"], path: json["path"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic> {
      "name": name,
      "path": path
    };
    return data;
  }

}