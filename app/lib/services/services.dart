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
  /// Base URL for the poll API (configurable via environment)
  final String baseUrl;
  final http.Client _client;

  PollService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000'),
        _client = client ?? http.Client();

  /// POST /polls endpoint - creates a new poll
  Future<Poll> createPoll({
    required String question,
    required DateTime deadline,
  }) async {
    final url = Uri.parse('$baseUrl/polls');

    try {
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question': question,
          'deadline': deadline.toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Poll(
          id: data['id'] as String,
          question: data['question'] as String,
          deadline: DateTime.parse(data['deadline'] as String),
        );
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Bad request: ${error['message'] ?? 'Invalid input'}');
      } else if (response.statusCode == 500) {
        throw Exception('Server error: Failed to create poll');
      } else {
        throw Exception('Failed to create poll: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }
}

class HarborlineServices {
  HarborlineServices({http.Client? httpClient})
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
        polls = PollService(client: httpClient);

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
