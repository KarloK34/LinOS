import 'package:equatable/equatable.dart';

class UserBalance extends Equatable {
  final double currentBalance;
  final DateTime lastUpdated;

  const UserBalance({required this.currentBalance, required this.lastUpdated});

  UserBalance copyWith({double? currentBalance, DateTime? lastUpdated}) {
    return UserBalance(
      currentBalance: currentBalance ?? this.currentBalance,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory UserBalance.empty() {
    return UserBalance(currentBalance: 0.0, lastUpdated: DateTime.now());
  }

  @override
  List<Object?> get props => [currentBalance, lastUpdated];
}
