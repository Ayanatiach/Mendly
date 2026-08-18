/// Tracks the lifecycle stage of a maintenance ticket
enum TicketStatus {
  reported,   // Newly submitted by student, waiting for dispatch
  inProgress, // Personnel accepted or arrived at location
  resolved,   // Personnel marked as fixed, 7-day countdown starts
  reopened,   // Student indicated the fix was unsatisfactory
}

/// Severity classification to help personnel prioritize issues
enum TicketSeverity {
  low,
  medium,
  critical,
}

/// Core data model representing an infrastructure issue on campus
class TicketModel {
  final String id;
  final String title;
  final String description;
  final String building;
  final String room;
  final TicketSeverity severity;
  TicketStatus status;
  final String? imageUrl;
  final DateTime createdAt;
  DateTime? arrivedAt;
  DateTime? resolvedAt;
  
  /// True if personnel marked arrival within <= 10 minutes of ticket creation
  bool isBonusEligible;
  
  /// True if 7 days have passed without the ticket being reopened
  bool bonusPaid;
  
  /// ID of the maintenance worker handling the ticket
  String? assignedPersonnelId;
  
  /// Email of the student who created the ticket
  final String studentEmail;
  
  /// Photo proof submitted by personnel after fixing the issue
  String? resolutionImageUrl;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.building,
    required this.room,
    required this.severity,
    this.status = TicketStatus.reported,
    this.imageUrl,
    required this.createdAt,
    this.arrivedAt,
    this.resolvedAt,
    this.isBonusEligible = false,
    this.bonusPaid = false,
    this.assignedPersonnelId,
    required this.studentEmail,
    this.resolutionImageUrl,
  });

  /// Computes the remaining seconds from the 10-minute SLA window
  int get remainingSecondsForSla {
    // 10 minutes = 600 seconds
    final elapsed = DateTime.now().difference(createdAt).inSeconds;
    final remaining = 600 - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  /// Calculates whether 7 days have elapsed since resolution
  bool get hasPassedSevenDaysHold {
    if (resolvedAt == null) return false;
    final daysElapsed = DateTime.now().difference(resolvedAt!).inDays;
    return daysElapsed >= 7;
  }
}