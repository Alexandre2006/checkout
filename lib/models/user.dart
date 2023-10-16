class CheckoutUser {
  String uuid;
  String name;
  String email;
  String profilePicture;
  bool admin;

  CheckoutUser({
    required this.uuid,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.admin,
  });
}
