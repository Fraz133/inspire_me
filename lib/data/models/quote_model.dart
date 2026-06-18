import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  final String id;
  final String text;
  final String author;
  final DateTime? createdAt;
  final String? uploadedBy;
  bool isFavorite;

  QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    this.createdAt,
    this.uploadedBy,
    this.isFavorite = false,
  });

  factory QuoteModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return QuoteModel(
      id: docId ?? map['id'] ?? '',
      text: map['text'] ?? '',
      author: map['author'] ?? 'Unknown',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      uploadedBy: map['uploadedBy'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'uploadedBy': uploadedBy,
      'isFavorite': isFavorite,
    };
  }

  QuoteModel copyWith({
    String? id,
    String? text,
    String? author,
    DateTime? createdAt,
    String? uploadedBy,
    bool? isFavorite,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
