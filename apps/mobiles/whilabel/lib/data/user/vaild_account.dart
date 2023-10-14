class VaildAccount {
  VaildAccount({
    required this.isLogined,
    required this.isNewbie,
    required this.isDelted,
  });
  final bool isLogined;
  final bool isNewbie;
  final bool isDelted;

  VaildAccount copyWith({
    bool? isLogined,
    bool? isNewbie,
    bool? isDelted,
  }) {
    return VaildAccount(
      isLogined: isLogined ?? this.isLogined,
      isNewbie: isNewbie ?? this.isNewbie,
      isDelted: isDelted ?? this.isDelted,
    );
  }
}
