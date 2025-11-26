// Path: lib/features/centers/presentation/find_centers_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vitaro/core/theme/app_theme.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';
import 'package:vitaro/features/centers/presentation/cubit/find_centers_cubit.dart';
import 'package:vitaro/features/centers/presentation/select_center_screen.dart';

// *** SHARED WIDGETS IMPORTS ***
import 'package:vitaro/shared_widgets/screen_app_bar.dart';
import 'package:vitaro/shared_widgets/custom_text_field.dart';

class FindCentersScreen extends StatelessWidget {
  final int initialIndex;
  const FindCentersScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FindCentersCubit()..loadCenters(),
      child: _FindCentersView(initialIndex: initialIndex),
    );
  }
}

class _FindCentersView extends StatefulWidget {
  final int initialIndex;
  const _FindCentersView({required this.initialIndex});

  @override
  State<_FindCentersView> createState() => _FindCentersViewState();
}

class _FindCentersViewState extends State<_FindCentersView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController; // Added controller
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _searchController = TextEditingController();

    // Listen to the controller to update search query
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    if (widget.initialIndex == 1) {
      context.read<FindCentersCubit>().loadCenters();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. USE SHARED APP BAR
      appBar: const ScreenAppBar(title: 'Find Centers'),
      body: BlocConsumer<FindCentersCubit, FindCentersState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty &&
              state.status == FindCentersStatus.loaded) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.centers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError && state.centers.isEmpty) {
            return _ErrorView(
              onRetry: () {
                context.read<FindCentersCubit>().loadCenters();
              },
            );
          }

          final filteredCenters = state.centers
              .where(
                (center) => center.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

          return Column(
            children: [
              // 2. TabBar moved here to work with Shared AppBar
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryRed,
                  unselectedLabelColor: AppTheme.textLight,
                  indicatorColor: AppTheme.primaryRed,
                  tabs: const [
                    Tab(text: 'List'),
                    Tab(text: 'Map'),
                  ],
                ),
              ),
              // 3. USE SHARED TEXT FIELD
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomTextField(
                  controller: _searchController,
                  hintText: 'Search hospitals...',
                  prefixIcon: Icons.search,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Better for maps
                  children: [
                    _CentersListView(centers: filteredCenters),
                    _CentersMapView(
                      centers: filteredCenters,
                      userPosition: state.userPosition,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ... _CentersListView, _CentersMapView, and _ErrorView remain the same ...
// (Copy them from your previous file, they don't need shared widgets inside the list items)
class _CentersListView extends StatelessWidget {
  const _CentersListView({required this.centers});

  final List<BloodCenter> centers;

  @override
  Widget build(BuildContext context) {
    if (centers.isEmpty) {
      return const Center(child: Text('No centers found nearby'));
    }

    return ListView.builder(
      itemCount: centers.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final center = centers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              center.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(center.address),
                const SizedBox(height: 4),
                Text('Hours: ${center.openingHours}'),
                const SizedBox(height: 4),
                Text(
                  center.status,
                  style: TextStyle(
                    color: center.isOpen ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectCenterScreen(center: center),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CentersMapView extends StatelessWidget {
  const _CentersMapView({required this.centers, required this.userPosition});

  final List<BloodCenter> centers;
  final Position? userPosition;

  @override
  Widget build(BuildContext context) {
    if (centers.isEmpty) {
      return const Center(child: Text('No centers to display on map'));
    }

    final initialTarget = userPosition != null
        ? LatLng(userPosition!.latitude, userPosition!.longitude)
        : centers.first.coordinates;

    final markers = centers
        .map(
          (center) => Marker(
            markerId: MarkerId(center.id),
            position: center.coordinates,
            infoWindow: InfoWindow(
              title: center.name,
              snippet: center.address,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectCenterScreen(center: center),
                  ),
                );
              },
            ),
          ),
        )
        .toSet();

    if (userPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(userPosition!.latitude, userPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialTarget, zoom: 12),
      myLocationEnabled: userPosition != null,
      myLocationButtonEnabled: true,
      markers: markers,
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.primaryRed, size: 48),
          const SizedBox(height: 12),
          const Text('Could not load centers'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
