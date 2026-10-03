import 'package:flutter/material.dart';
import '../data/models.dart';
import '../services/services.dart';

enum VoyageMode { atHome, onBoard }

class AppState extends ChangeNotifier {
  AppState(this.services);

  final HarborlineServices services;
  VoyageMode mode = VoyageMode.onBoard;
  String? lastHybridResult;
  final List<Poll> _polls = [];

  bool get signedIn => services.auth.isSignedIn;

  Future<void> signIn() async {
    await services.auth.signInDemo();
    services.analytics.track('demo_sign_in');
    notifyListeners();
  }

  Future<void> signOut() async {
    await services.auth.signOut();
    notifyListeners();
  }

  void setMode(VoyageMode value) {
    mode = value;
    notifyListeners();
  }

  void updateDisplayName(String name) {
    services.profile.updateDisplayName(name);
    notifyListeners();
  }

  void setChildChat(bool v) {
    services.profile.profile.childChatAllowed = v;
    notifyListeners();
  }

  void setChildWifi(bool v) {
    services.profile.profile.childWifiAllowed = v;
    notifyListeners();
  }

  void setChildPurchases(bool v) {
    services.profile.profile.childPurchasesAllowed = v;
    notifyListeners();
  }

  void setPromoEmail(bool v) {
    services.profile.profile.promoEmail = v;
    notifyListeners();
  }

  void setPromoPush(bool v) {
    services.profile.profile.promoPush = v;
    notifyListeners();
  }

  Future<void> completeHybrid(String name) async {
    await services.hybrid.openFlow(name);
    lastHybridResult = '$name submitted (demo)';
    notifyListeners();
  }

  // Poll management
  List<Poll> get polls => List.unmodifiable(_polls);

  void savePoll(Poll poll) {
    _polls.add(poll);
    notifyListeners();
  }

  Poll? getPollByToken(String token) {
    try {
      return _polls.firstWhere((p) => p.shareToken == token);
    } catch (_) {
      return null;
    }
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope missing');
    return scope!.notifier!;
  }
}
