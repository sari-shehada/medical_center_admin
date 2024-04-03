// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Disease {
  final int id;
  final String name;
  Disease({
    required this.id,
    required this.name,
  });

  Disease copyWith({
    int? id,
    String? name,
  }) {
    return Disease(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Disease.fromMap(Map<String, dynamic> map) {
    return Disease(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Disease.fromJson(String source) =>
      Disease.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Disease(id: $id, name: $name)';

  @override
  bool operator ==(covariant Disease other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
