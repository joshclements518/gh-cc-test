import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/mock_catalog.dart';
import '../data/models.dart';

/// Core + external facades (mock implementations — no vendor SDKs).
class AuthService {
  bool _signedIn = false;
  bool get isSignedIn => _signedIn;
  Future<void> signInDemo() async => _signedIn = true;
  Future<void> signOut() async => _signedIn = false;
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

class PollService {
  final String baseUrl;

  PollService({this.baseUrl = 'http://localhost:3000'});

  Future<Poll> createPoll({
    required String question,
    required DateTime deadline,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/polls'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'question': question,
        'deadline': deadline.toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Poll(
        id: data['id'].toString(),
        question: data['question'],
        deadline: DateTime.parse(data['deadline']),
      );
    } else {
      throw Exception('Failed to create poll: ${response.statusCode}');
    }
  }
}

class HarborlineServices {
  HarborlineServices()
      : auth = AuthService(),
        profile = GuestProfileService(),
        analytics = AnalyticsService(),
        experience = ExperiencePlatform(),
        wearable = WearableBle(),
        payments = PaymentsService(),
        hybrid = HybridWebBridge(),
        push = PushMessagingFacade(),
        chat = ChatFacade(),
        support = SupportFacade(),
        privacy = PrivacyConsentFacade(),
        polls = PollService();

  final AuthService auth;
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
  final PollService polls;
}
