import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vitaro/core/theme/app_theme.dart';

// Cubit & State
import 'package:vitaro/features/dashboard/controllers/dashboard_cubit.dart';
import 'package:vitaro/features/dashboard/controllers/dashboard_state.dart';

// Models
import 'package:vitaro/features/dashboard/models/dashboard_user.dart';
import 'package:vitaro/features/dashboard/models/recent_activity.dart';

// Widgets
import 'package:vitaro/features/dashboard/widgets/blood_type_card.dart';
import 'package:vitaro/features/dashboard/widgets/recent_activity_tile.dart';
import 'package:vitaro/features/centers/presentation/find_centers_screen.dart';

// Shared Widgets
import 'package:vitaro/shared_widgets/info_card.dart';
import 'package:vitaro/shared_widgets/screen_app_bar.dart';

// 1. WRAPPER WIDGET (PROVIDES THE CUBIT)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // This creates the Cubit and fetches data immediately
      create: (_) => DashboardCubit()..fetchDashboardData(),
      child: const _DashboardView(),
    );
  }
}

// 2. VIEW WIDGET (BUILDS THE UI)
class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenAppBar(
        title: 'Vitaro',
        showBackArrow: false,
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error: ${state.message}', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () =>
                        context.read<DashboardCubit>().fetchDashboardData(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed),
                    child: const Text("Retry"))
              ],
            ));
          }
          if (state is DashboardLoaded) {
            return _buildDashboardContent(context, state.user, state.activities);
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    DashboardUser user,
    List<RecentActivity> activities,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().fetchDashboardData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BloodTypeCard(user: user),
            const SizedBox(height: 24),
            Row(
              children: [
                InfoCard(
                  title: 'Hemoglobin',
                  value: user.hemoglobin.toStringAsFixed(1),
                  unit: 'g/dL',
                ),
                const SizedBox(width: 12),
                InfoCard(
                  title: 'Blood Pressure',
                  value:
                      '${user.bloodPressureSystolic}/${user.bloodPressureDiastolic}',
                  unit: 'mmHg',
                ),
                const SizedBox(width: 12),
                InfoCard(
                  title: 'Pulse',
                  value: user.pulse.toString(),
                  unit: 'bpm',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const DashboardMapPreview(),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (activities.isEmpty)
              const Center(child: Text('No recent activity.')),
            if (activities.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return RecentActivityTile(activity: activities[index]);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class DashboardMapPreview extends StatelessWidget {
  const DashboardMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FindCentersScreen(initialIndex: 1),
          ),
        );
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              const GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(-1.9441, 30.0619),
                  zoom: 13,
                ),
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
              ),
              Container(color: Colors.black.withValues(alpha: 0.1)),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8)
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.map, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text("Find Nearby Centers",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}