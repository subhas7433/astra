import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String astrologerId;
  final String userId;
  final String userName;
  final int rating; // 1-5
  final String text;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.astrologerId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.text,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      astrologerId: map['astrologerId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      rating: map['rating']?.toInt() ?? 0,
      text: map['text'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'astrologerId': astrologerId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, astrologerId, userId, userName, rating, text, createdAt];
}
