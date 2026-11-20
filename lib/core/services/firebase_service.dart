import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/bookmark_model.dart';

class FirebaseService extends ChangeNotifier {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  StreamSubscription<User?>? _authSub;
  bool _initialized = false;

  User? _currentUser;
  bool _isSyncing = false;

  User? get currentUser => _currentUser;
  bool get isSyncing => _isSyncing;
  bool get isCloudConfigured => _initialized;
  bool get isAuthenticated => _initialized && _currentUser != null;

  FirebaseService() {
    _initAuth();
  }

  void _initAuth() {
    try {
      if (Firebase.apps.isEmpty) {
        _initialized = false;
        return;
      }
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _initialized = true;
      _authSub = _auth!.authStateChanges().listen((user) {
        _currentUser = user;
        notifyListeners();
      });
    } catch (e) {
      _initialized = false;
      debugPrint("Firebase Auth/Firestore unavailable (local mode active): $e");
    }
  }

  /// Sign in anonymously for seamless guest sync when Firebase is configured
  Future<void> signInAnonymously() async {
    if (!_initialized || _auth == null) return;
    try {
      final userCredential = await _auth!.signInAnonymously();
      _currentUser = userCredential.user;
      notifyListeners();
    } catch (e) {
      debugPrint("Firebase Auth Anonymous Error: $e");
    }
  }

  /// Sync Last Read to Cloud Firestore
  Future<void> saveLastReadToCloud(BookmarkModel lastRead) async {
    if (!_initialized || _currentUser == null || _firestore == null) return;
    try {
      _isSyncing = true;
      notifyListeners();

      await _firestore!
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('last_read')
          .doc('current')
          .set(lastRead.toJson());
    } catch (e) {
      debugPrint("Firestore Save Last Read Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// Sync Bookmark to Cloud Firestore
  Future<void> saveBookmarkToCloud(BookmarkModel bookmark) async {
    if (!_initialized || _currentUser == null || _firestore == null) return;
    try {
      _isSyncing = true;
      notifyListeners();

      await _firestore!
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('bookmarks')
          .doc(bookmark.id)
          .set(bookmark.toJson());
    } catch (e) {
      debugPrint("Firestore Save Bookmark Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// Delete Bookmark from Cloud Firestore
  Future<void> deleteBookmarkFromCloud(String bookmarkId) async {
    if (!_initialized || _currentUser == null || _firestore == null) return;
    try {
      await _firestore!
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('bookmarks')
          .doc(bookmarkId)
          .delete();
    } catch (e) {
      debugPrint("Firestore Delete Bookmark Error: $e");
    }
  }

  /// Fetch All Bookmarks from Cloud
  Stream<List<BookmarkModel>> getBookmarksStream() {
    if (!_initialized || _currentUser == null || _firestore == null) {
      return Stream.value([]);
    }

    return _firestore!
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('bookmarks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookmarkModel.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
