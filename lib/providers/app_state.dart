import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/ticket_model.dart';

/// Central state store managing user session, ticket lifecycle, and bonus payouts
class AppState extends ChangeNotifier {
  UserModel? _currentUser;
  final List<TicketModel> _tickets = [];
  ThemeMode _currentTheme = ThemeMode.dark;

  AppState() {
    _populateInitialMockData();
  }

  // --- Theme Management ---
  ThemeMode get currentTheme => _currentTheme;
  bool get isDarkMode => _currentTheme == ThemeMode.dark;

  void toggleTheme() {
    _currentTheme =
        _currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // --- Getters ---
  UserModel? get currentUser => _currentUser;
  List<TicketModel> get tickets => List.unmodifiable(_tickets);

  /// Filters tickets submitted by the currently logged-in student
  List<TicketModel> get studentTickets {
    if (_currentUser == null) return [];
    return _tickets
        .where((t) => t.studentEmail == _currentUser!.email)
        .toList();
  }

  /// Urgent dispatch queue for personnel (active, non-resolved tickets)
  List<TicketModel> get openPersonnelTickets {
    return _tickets.where((t) => t.status != TicketStatus.resolved).toList();
  }

// --- Domain Restricted Authentication ---
  /// Strictly validates that an email belongs to the BMU domain
  bool validateUniversityEmail(String email) {
    final clean = email.trim().toLowerCase();
    // Only allows official BMU student or staff emails
    return clean.endsWith('@bmu.edu.in');
  }

  /// Logs in the user with role-based credential validation.
  ///
  /// - **Student**: must have a valid `@bmu.edu.in` email.
  /// - **Personnel**: must be exactly `personnel@enviro.in`.
  ///
  /// Returns `true` on success, `false` on any validation failure.
  bool login(String email, UserRole role) {
    final clean = email.trim().toLowerCase();

    if (role == UserRole.personnel) {
      // Personnel are exclusively authenticated via a single locked credential
      if (clean != 'personnel@enviro.in') return false;
    } else {
      // Students (and any other role) must belong to the BMU domain
      if (!validateUniversityEmail(clean)) return false;
    }

    _currentUser = UserModel(
      id: 'USER_${DateTime.now().millisecondsSinceEpoch}',
      email: clean,
      name: clean.split('@').first.replaceAll('.', ' ').toUpperCase(),
      role: role,
    );
    notifyListeners();
    return true;
  }

  /// Logs out the user and clears session
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Authenticates a teacher / professor using their BMU institutional email.
  /// Teachers are routed to a read-only incident overview on the dashboard.
  ///
  /// Returns `true` on success, `false` if the email domain is invalid.
  bool loginAsTeacher(String email) {
    if (!validateUniversityEmail(email)) return false;

    _currentUser = UserModel(
      id: 'TCHR_${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim().toLowerCase(),
      name: email.split('@').first.replaceAll('.', ' ').toUpperCase(),
      role: UserRole.teacher,
    );
    notifyListeners();
    return true;
  }

  // --- Student Actions ---

  /// Adds a new damage report ticket submitted via the Report Damage form.
  /// Generates a mock ID in the format 'TICK-100X', sets status to
  /// [TicketStatus.reported], inserts at the top of the list, and notifies.
  void addTicket({
    required String title,
    required String description,
    required String building,
    required String room,
    TicketSeverity severity = TicketSeverity.medium,
    String? imageUrl,
  }) {
    if (_currentUser == null) return;

    final mockId = 'TICK-${1001 + _tickets.length}';
    final newTicket = TicketModel(
      id: mockId,
      title: title,
      description: description,
      building: building,
      room: room,
      severity: severity,
      status: TicketStatus.reported,
      createdAt: DateTime.now(),
      studentEmail: _currentUser!.email,
      imageUrl: imageUrl ??
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    );

    _tickets.insert(0, newTicket);
    notifyListeners();
  }

  /// Creates a new damage report ticket (legacy method — prefer addTicket)
  void createTicket({
    required String title,
    required String description,
    required String building,
    required String room,
    required TicketSeverity severity,
    String? imageUrl,
  }) {
    if (_currentUser == null) return;

    final newTicket = TicketModel(
      id: 'TCK-${_tickets.length + 101}',
      title: title,
      description: description,
      building: building,
      room: room,
      severity: severity,
      status: TicketStatus.reported,
      createdAt: DateTime.now(),
      studentEmail: _currentUser!.email,
      imageUrl: imageUrl ??
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    );

    _tickets.insert(0, newTicket);
    notifyListeners();
  }

  /// Re-opens an issue if student finds repair inadequate (voids personnel bonus)
  void reopenTicket(String ticketId) {
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      _tickets[index].status = TicketStatus.reopened;
      _tickets[index].isBonusEligible = false; // Bonus is canceled immediately
      _tickets[index].bonusPaid = false;
      notifyListeners();
    }
  }

  // --- Personnel Actions & Incentive Logic ---
  /// Marks arrival at the scene and validates the 10-minute SLA window
  void markArrival(String ticketId) {
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) return;

    final ticket = _tickets[index];
    ticket.arrivedAt = DateTime.now();
    ticket.status = TicketStatus.inProgress;
    ticket.assignedPersonnelId = _currentUser?.id;

    // SLA Calculation: Check if arrival happened within 10 minutes (600 seconds)
    final diffInSeconds =
        ticket.arrivedAt!.difference(ticket.createdAt).inSeconds;
    if (diffInSeconds <= 600) {
      ticket.isBonusEligible =
          true; // Qualified for the ₹20 bonus pending 7-day hold
    } else {
      ticket.isBonusEligible = false; // Arrival exceeded 10 minutes
    }

    notifyListeners();
  }

  /// Resolves the ticket and records resolution time
  void resolveTicket(String ticketId, String proofUrl) {
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) return;

    final ticket = _tickets[index];
    ticket.status = TicketStatus.resolved;
    ticket.resolvedAt = DateTime.now();
    ticket.resolutionImageUrl = proofUrl;

    notifyListeners();
  }

  /// Simulates fast-forwarding 7 days for demo evaluation
  void simulateFastForward7Days() {
    for (var ticket in _tickets) {
      if (ticket.status == TicketStatus.resolved && ticket.resolvedAt != null) {
        // Move resolution date 8 days into the past
        ticket.resolvedAt =
            ticket.resolvedAt!.subtract(const Duration(days: 8));
        // If it was eligible and wasn't reopened, unlock payout
        if (ticket.isBonusEligible) {
          ticket.bonusPaid = true;
        }
      }
    }
    notifyListeners();
  }

  /// Computes personnel earnings statistics
  Map<String, double> getPersonnelEarnings() {
    double baseEarnings = 500.0; // Base fixed stipend
    double pendingBonuses = 0.0;
    double paidBonuses = 0.0;

    for (var ticket in _tickets) {
      if (ticket.isBonusEligible) {
        if (ticket.bonusPaid ||
            (ticket.status == TicketStatus.resolved &&
                ticket.hasPassedSevenDaysHold)) {
          paidBonuses += 20.0;
        } else if (ticket.status == TicketStatus.resolved ||
            ticket.status == TicketStatus.inProgress) {
          pendingBonuses += 20.0;
        }
      }
    }

    return {
      'base': baseEarnings,
      'pending': pendingBonuses,
      'paid': paidBonuses,
      'total': baseEarnings + paidBonuses,
    };
  }

  // --- Initial Mock Data ---
  void _populateInitialMockData() {
    _tickets.addAll([
      TicketModel(
        id: 'TCK-101',
        title: 'Broken Water Cooler Tap',
        description: 'Water is leaking continuously on the 2nd floor corridor.',
        building: 'Science Block B',
        room: 'Floor 2, Hallway',
        severity: TicketSeverity.critical,
        status: TicketStatus.reported,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
        studentEmail: 'alex@university.edu',
        imageUrl:
            'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
      ),
      TicketModel(
        id: 'TCK-102',
        title: 'Flickering LED Tube Lights',
        description:
            'Two tube lights near the projector are constantly flickering.',
        building: 'Engineering Block 1',
        room: 'Room 304',
        severity: TicketSeverity.medium,
        status: TicketStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
        arrivedAt: DateTime.now().subtract(const Duration(minutes: 2)),
        isBonusEligible: true,
        studentEmail: 'student@inst.ac.in',
        imageUrl:
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=600&q=80',
      ),
    ]);
  }
}
