import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import '../models/user_model.dart';
import 'cloudinary_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get user role
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.get('role') ?? 'user';
      }
      return 'user';
    } catch (e) {
      print('Error getting user role: $e');
      return 'user';
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        // Get user data from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        } else {
          // Create new user document if it doesn't exist
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? 'User',
            role: 'user', // Default role
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
          return newUser;
        }
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      throw e;
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        // Create user document in Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          role: 'user', // Default role
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      print('Error registering: $e');
      throw e;
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        } else {
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? 'User',
            role: 'user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
          return newUser;
        }
      }
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  // Update user role (for admin functionality)
  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'role': newRole,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating user role: $e');
      throw e;
    }
  }

  // Get all users (for admin panel)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map(
      (snapshot) => snapshot.docs.map(
        (doc) => UserModel.fromMap(doc.data())
      ).toList()
    );
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      throw e;
    }
  }

  // Pick image from gallery or camera
  Future<XFile?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      return image;
    } catch (e) {
      print('Error picking image: $e');
      throw e;
    }
  }

  // Upload profile image to Cloudinary
  Future<String?> uploadProfileImage(String uid, XFile imageFile) async {
    try {
      return await CloudinaryService.uploadProfileImage(uid, imageFile);
    } catch (e) {
      print('Error uploading profile image to Cloudinary: $e');
      throw e;
    }
  }

  // Update user profile image URL in Firestore
  Future<void> updateProfileImageUrl(String uid, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': imageUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating profile image URL: $e');
    }
  }

  // Delete profile image from Cloudinary
  Future<bool> deleteProfileImage(String uid) async {
    try {
      return await CloudinaryService.deleteProfileImage(uid);
    } catch (e) {
      print('Error deleting profile image: $e');
      return false;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, String name, String email) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
        'email': email,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating user profile: $e');
      throw e;
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print('Error getting current user data: $e');
      throw e;
    }
  }

  // Submit feedback to Firestore with user info
  Future<void> submitFeedback(String uid, String name, String email, String feedback) async {
    try {
      await _firestore.collection('feedback').add({
        'uid': uid,
        'name': name,
        'email': email,
        'feedback': feedback,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error submitting feedback: $e');
      throw e;
    }
  }
}
