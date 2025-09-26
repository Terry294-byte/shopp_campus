import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../models/group_buy_model.dart';
import '../services/toast_service.dart';

class GroupBuyProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<GroupBuyModel> _activeGroupBuys = [];
  List<GroupBuyModel> _myGroupBuys = [];
  bool _isLoading = false;

  List<GroupBuyModel> get activeGroupBuys => _activeGroupBuys;
  List<GroupBuyModel> get myGroupBuys => _myGroupBuys;
  bool get isLoading => _isLoading;
  User? get currentUser => _auth.currentUser;

  Future<void> fetchActiveGroupBuys() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('groupBuys')
          .where('isActive', isEqualTo: true)
          .where('expiresAt', isGreaterThan: DateTime.now().toIso8601String())
          .get();

      _activeGroupBuys = snapshot.docs
          .map((doc) => GroupBuyModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ToastService.showError('Error fetching group buys: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyGroupBuys() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('groupBuys')
          .where('participantIds', arrayContains: user.uid)
          .get();

      _myGroupBuys = snapshot.docs
          .map((doc) => GroupBuyModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ToastService.showError('Error fetching my group buys: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createGroupBuy(String productId, String productName, String productImage, double originalPrice, int targetParticipants, double discountPercentage) async {
    final user = _auth.currentUser;
    if (user == null) {
      ToastService.showError('Please login to create a group buy');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      String shareCode = _generateShareCode();
      GroupBuyModel groupBuy = GroupBuyModel(
        id: _firestore.collection('groupBuys').doc().id,
        creatorId: user.uid,
        productId: productId,
        productName: productName,
        productImage: productImage,
        originalPrice: originalPrice,
        targetParticipants: targetParticipants,
        currentParticipants: 1,
        discountPercentage: discountPercentage,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(Duration(days: 7)),
        participantIds: [user.uid],
        isActive: true,
        shareCode: shareCode,
      );

      await _firestore.collection('groupBuys').doc(groupBuy.id).set(groupBuy.toMap());

      ToastService.showSuccess('Group buy created successfully!');
      await fetchActiveGroupBuys();
      await fetchMyGroupBuys();
    } catch (e) {
      ToastService.showError('Error creating group buy: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> joinGroupBuy(String groupBuyId) async {
    final user = _auth.currentUser;
    if (user == null) {
      ToastService.showError('Please login to join a group buy');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot doc = await _firestore.collection('groupBuys').doc(groupBuyId).get();
      if (!doc.exists) {
        ToastService.showError('Group buy not found');
        return;
      }

      GroupBuyModel groupBuy = GroupBuyModel.fromMap(doc.data() as Map<String, dynamic>);

      if (groupBuy.participantIds.contains(user.uid)) {
        ToastService.showInfo('You are already part of this group buy');
        return;
      }

      if (groupBuy.isComplete || !groupBuy.isActive || groupBuy.isExpired) {
        ToastService.showError('This group buy is no longer available');
        return;
      }

      List<String> updatedParticipants = List.from(groupBuy.participantIds)..add(user.uid);
      int updatedCount = updatedParticipants.length;

      await _firestore.collection('groupBuys').doc(groupBuyId).update({
        'participantIds': updatedParticipants,
        'currentParticipants': updatedCount,
      });

      ToastService.showSuccess('Successfully joined the group buy!');
      await fetchActiveGroupBuys();
      await fetchMyGroupBuys();
    } catch (e) {
      ToastService.showError('Error joining group buy: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> joinGroupBuyByCode(String shareCode) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('groupBuys')
          .where('shareCode', isEqualTo: shareCode)
          .where('isActive', isEqualTo: true)
          .where('expiresAt', isGreaterThan: DateTime.now().toIso8601String())
          .get();

      if (snapshot.docs.isEmpty) {
        ToastService.showError('Invalid or expired group buy code');
        return;
      }

      String groupBuyId = snapshot.docs.first.id;
      await joinGroupBuy(groupBuyId);
    } catch (e) {
      ToastService.showError('Error joining group buy: $e');
    }
  }

  Future<void> shareGroupBuy(GroupBuyModel groupBuy) async {
    String shareText = 'Join my group buy for ${groupBuy.productName} and save ${groupBuy.discountPercentage}%! Use code: ${groupBuy.shareCode}';
    await Share.share(shareText);
  }

  String _generateShareCode() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(8, 13).toUpperCase();
  }

  Future<void> checkAndUpdateGroupBuys() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('groupBuys')
          .where('isActive', isEqualTo: true)
          .get();

      for (var doc in snapshot.docs) {
        GroupBuyModel groupBuy = GroupBuyModel.fromMap(doc.data() as Map<String, dynamic>);
        if (groupBuy.isExpired || groupBuy.isComplete) {
          await _firestore.collection('groupBuys').doc(groupBuy.id).update({'isActive': false});
        }
      }
    } catch (e) {
      print('Error updating group buys: $e');
    }
  }
}
