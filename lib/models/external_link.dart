// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExternalLink {
  final int id;
  final int diseaseId;
  final String title;
  final String brief;
  final String imageUrl;
  final String link;
  ExternalLink({
    required this.id,
    required this.diseaseId,
    required this.title,
    required this.brief,
    required this.imageUrl,
    required this.link,
  });

  ExternalLink copyWith({
    int? id,
    int? diseaseId,
    String? title,
    String? brief,
    String? imageUrl,
    String? link,
  }) {
    return ExternalLink(
      id: id ?? this.id,
      diseaseId: diseaseId ?? this.diseaseId,
      title: title ?? this.title,
      brief: brief ?? this.brief,
      imageUrl: imageUrl ?? this.imageUrl,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'diseaseId': diseaseId,
      'title': title,
      'brief': brief,
      'imageUrl': imageUrl,
      'link': link,
    };
  }

  factory ExternalLink.fromMap(Map<String, dynamic> map) {
    return ExternalLink(
      id: map['id'] as int,
      diseaseId: map['diseaseId'] as int,
      title: map['title'] as String,
      brief: map['brief'] as String,
      imageUrl: map['imageUrl'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExternalLink.fromJson(String source) =>
      ExternalLink.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExternalLink(id: $id, diseaseId: $diseaseId, title: $title, brief: $brief, imageUrl: $imageUrl, link: $link)';
  }

  @override
  bool operator ==(covariant ExternalLink other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.diseaseId == diseaseId &&
        other.title == title &&
        other.brief == brief &&
        other.imageUrl == imageUrl &&
        other.link == link;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        diseaseId.hashCode ^
        title.hashCode ^
        brief.hashCode ^
        imageUrl.hashCode ^
        link.hashCode;
  }
}
