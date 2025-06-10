import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
  @override
  List<Object?> get props => [];
}

class SettingsLoaded extends SettingsState {
  final bool transitStopNotificationsEnabled;
  final bool hasSystemPermission;
  final bool appSettingEnabled;

  const SettingsLoaded({
    required this.transitStopNotificationsEnabled,
    required this.hasSystemPermission,
    required this.appSettingEnabled,
  });

  SettingsLoaded copyWith({bool? transitStopNotificationsEnabled, bool? hasSystemPermission, bool? appSettingEnabled}) {
    return SettingsLoaded(
      transitStopNotificationsEnabled: transitStopNotificationsEnabled ?? this.transitStopNotificationsEnabled,
      hasSystemPermission: hasSystemPermission ?? this.hasSystemPermission,
      appSettingEnabled: appSettingEnabled ?? this.appSettingEnabled,
    );
  }

  @override
  List<Object?> get props => [transitStopNotificationsEnabled];
}

class SettingsError extends SettingsState {
  final String errorKey;
  final Object? originalError;

  const SettingsError(this.errorKey, {this.originalError});

  @override
  List<Object?> get props => [errorKey, originalError];
}

class SettingsPermissionDenied extends SettingsState {
  const SettingsPermissionDenied();

  @override
  List<Object?> get props => [];
}
