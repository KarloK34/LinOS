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

  @override
  List<Object?> get props => [currentBalance, lastUpdated];
}
