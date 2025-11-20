import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vitaro/features/centers/data/centers_repository.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';

part 'find_centers_state.dart';

class FindCentersCubit extends Cubit<FindCentersState> {
  FindCentersCubit({
    CentersRepository? repository,
    GeolocatorPlatform? geolocator,
  })  : _repository = repository ?? CentersRepository(),
        _geolocator = geolocator ?? GeolocatorPlatform.instance,
        super(const FindCentersState.initial());

  final CentersRepository _repository;
  final GeolocatorPlatform _geolocator;

  Future<void> loadCenters({bool requestLocation = true}) async {
    emit(state.copyWith(status: FindCentersStatus.loading, errorMessage: ''));
    try {
      Position? position;
      if (requestLocation) {
        position = await _determinePosition();
      }

      final centers = position != null
          ? await _repository.fetchNearbyCenters(position)
          : await _repository.fetchCenters();

      emit(state.copyWith(
        status: FindCentersStatus.loaded,
        centers: centers,
        userPosition: position,
      ));
    } on PermissionDeniedException {
      final centers = await _repository.fetchCenters();
      emit(state.copyWith(
        status: FindCentersStatus.loaded,
        centers: centers,
        errorMessage: 'Location permission denied. Showing all centers.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FindCentersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<Position?> _determinePosition() async {
    final serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionDeniedException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return _geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}

class PermissionDeniedException implements Exception {
  const PermissionDeniedException(this.message);

  final String message;

  @override
  String toString() => message;
}

