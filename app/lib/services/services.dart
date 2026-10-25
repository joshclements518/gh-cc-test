import '../data/mock_catalog.dart';
import '../data/models.dart';
import 'user_identity_service.dart';

/// Core + external facades (mock implementations — no vendor SDKs).
class AuthService {
  AuthService(this.userIdentity);

  final UserIdentityService userIdentity;
  bool get isSignedIn => userIdentity.hasIdentity;

  Future<void> signInDemo() async {
    // Honor system auth: identity is created via name entry dialog
    // This method kept for compatibility but auth now flows through UserIdentityService
  }

  Future<void> signOut() async {
    await userIdentity.clearIdentity();
  }
}

class GuestProfileService {
  GuestProfile get profile => MockCatalog.guest;
  void updateDisplayName(String name) => MockCatalog.guest.displayName = name;
}

class AnalyticsService {
  void track(String event, [Map<String, Object?>? props]) {
    // no-op facade (Adobe/AEP-shaped role)
  }
}

class ExperiencePlatform {
  Reservation get activeReservation => MockCatalog.reservation;
}

class WearableBle {
  bool get isConnected => false;
  Future<void> pairDemo() async {}
}

class PaymentsService {
  List<FolioCharge> get charges => MockCatalog.folio;
  double get balance =>
      MockCatalog.folio.fold<double>(0, (sum, c) => sum + c.amount);
  Future<bool> makePayment(double amount) async => true;
}

class HybridWebBridge {
  Future<void> openFlow(String id) async {
    // UI hosts styled hybrid screens; bridge is a seam for later WebViews.
  }
}

class PushMessagingFacade {
  int get unreadApprox => MockCatalog.inbox.length;
}

class ChatFacade {
  List<ChatThread> get threads => MockCatalog.chats;
}

class SupportFacade {
  String get hoursLabel => 'Guest Services · Deck 3 · 24h';
}

class PrivacyConsentFacade {
  bool analyticsAllowed = true;
}

class HarborlineServices {
  HarborlineServices()
      : userIdentity = UserIdentityService(),
        profile = GuestProfileService(),
        analytics = AnalyticsService(),
        experience = ExperiencePlatform(),
        wearable = WearableBle(),
        payments = PaymentsService(),
        hybrid = HybridWebBridge(),
        push = PushMessagingFacade(),
        chat = ChatFacade(),
        support = SupportFacade(),
        privacy = PrivacyConsentFacade() {
    auth = AuthService(userIdentity);
  }

  final UserIdentityService userIdentity;
  late final AuthService auth;
  final GuestProfileService profile;
  final AnalyticsService analytics;
  final ExperiencePlatform experience;
  final WearableBle wearable;
  final PaymentsService payments;
  final HybridWebBridge hybrid;
  final PushMessagingFacade push;
  final ChatFacade chat;
  final SupportFacade support;
  final PrivacyConsentFacade privacy;

  /// Initialize async services (call before runApp)
  Future<void> init() async {
    await userIdentity.init();
  }
}
