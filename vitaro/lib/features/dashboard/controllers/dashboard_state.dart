import 'package:equatable/equatable.dart';
import 'package:vitaro/features/dashboard/models/dashboard_user.dart';
import 'package:vitaro/features/dashboard/models/recent_activity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardUser user;
  final List<RecentActivity> activities;
  const DashboardLoaded({required this.user, required this.activities});

  @override
  List<Object?> get props => [user, activities];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// New: unauthenticated state
class DashboardUnauthenticated extends DashboardState {}
