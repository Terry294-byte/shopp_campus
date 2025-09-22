class OrderItem {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final String userPhone;
  final String deliveryAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String? mpesaReceiptNumber;
  final String? checkoutRequestId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
    required this.deliveryAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.mpesaReceiptNumber,
    this.checkoutRequestId,
    required this.createdAt,
    this.updatedAt,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'userPhone': userPhone,
      'deliveryAddress': deliveryAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'mpesaReceiptNumber': mpesaReceiptNumber,
      'checkoutRequestId': checkoutRequestId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      userEmail: json['userEmail'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      deliveryAddress: json['deliveryAddress'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      status: json['status'],
      mpesaReceiptNumber: json['mpesaReceiptNumber'],
      checkoutRequestId: json['checkoutRequestId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  OrderModel copyWith({
    String? status,
    String? mpesaReceiptNumber,
    String? checkoutRequestId,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      userEmail: userEmail,
      userName: userName,
      userPhone: userPhone,
      deliveryAddress: deliveryAddress,
      items: items,
      totalAmount: totalAmount,
      status: status ?? this.status,
      mpesaReceiptNumber: mpesaReceiptNumber ?? this.mpesaReceiptNumber,
      checkoutRequestId: checkoutRequestId ?? this.checkoutRequestId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
