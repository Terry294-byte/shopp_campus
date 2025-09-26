class GroupBuyModel {
  final String id;
  final String creatorId;
  final String productId;
  final String productName;
  final String productImage;
  final double originalPrice;
  final int targetParticipants;
  final int currentParticipants;
  final double discountPercentage;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> participantIds;
  final bool isActive;
  final String shareCode;

  GroupBuyModel({
    required this.id,
    required this.creatorId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.originalPrice,
    required this.targetParticipants,
    required this.currentParticipants,
    required this.discountPercentage,
    required this.createdAt,
    required this.expiresAt,
    required this.participantIds,
    required this.isActive,
    required this.shareCode,
  });

  factory GroupBuyModel.fromMap(Map<String, dynamic> map) {
    return GroupBuyModel(
      id: map['id'] ?? '',
      creatorId: map['creatorId'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      originalPrice: (map['originalPrice'] ?? 0.0).toDouble(),
      targetParticipants: map['targetParticipants'] ?? 0,
      currentParticipants: map['currentParticipants'] ?? 0,
      discountPercentage: (map['discountPercentage'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      expiresAt: DateTime.parse(map['expiresAt'] ?? DateTime.now().add(Duration(days: 7)).toIso8601String()),
      participantIds: List<String>.from(map['participantIds'] ?? []),
      isActive: map['isActive'] ?? true,
      shareCode: map['shareCode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'originalPrice': originalPrice,
      'targetParticipants': targetParticipants,
      'currentParticipants': currentParticipants,
      'discountPercentage': discountPercentage,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'participantIds': participantIds,
      'isActive': isActive,
      'shareCode': shareCode,
    };
  }

  double get discountedPrice => originalPrice * (1 - discountPercentage / 100);

  bool get isComplete => currentParticipants >= targetParticipants;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
