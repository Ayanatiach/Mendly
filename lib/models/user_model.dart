/// Represents the allowed user roles in the Mendly ecosystem.
enum UserRole {
  student,
  personnel,
}

/// Represents the authenticated user profile.
class UserModel {
  /// Unique identifier (e.g., student ID or email hash)
  final String id;

  /// User's official university email address
  final String email;

  /// Full display name
  final String name;

  /// Role assigned to the user
  final UserRole role;

  /// Constructor to initialize user attributes
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}
