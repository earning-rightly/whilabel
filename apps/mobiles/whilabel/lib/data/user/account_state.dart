class AccountState {
  AccountState({
    required this.isLogined,
    required this.isNewbie,
    required this.isDeleted,
  });
  final bool isLogined;
  final bool isNewbie;
  final bool isDeleted;

  AccountState copyWith({
    bool? isLogined,
    bool? isNewbie,
    bool? isDeleted,
  }) {
    return AccountState(
      isLogined: isLogined ?? this.isLogined,
      isNewbie: isNewbie ?? this.isNewbie,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
