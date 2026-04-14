import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Service GPS centralisé — source unique de la position dans l'app.
/// Consommé par : carte OSM, GPS photo, GPS recherche, etc.
class GpsService extends ChangeNotifier {
  // ── Singleton ────────────────────────────────────────────────────────────────
  static final GpsService instance = GpsService._();
  GpsService._();

  // ── État ─────────────────────────────────────────────────────────────────────
  LatLng? valueGPS;    // Position courante — null tant qu'elle n'est pas obtenue
  String? valueCity;   // Nom de ville résolu depuis valueGPS
  bool    loading = false;
  String? error;

  // ── GPS ACTUEL ───────────────────────────────────────────────────────────────

  /// Demande la position actuelle du téléphone et met à jour [valueGPS].
  Future<void> fetchCurrentPosition() async {
    loading = true;
    error   = null;
    notifyListeners();

    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        error   = 'Permission de localisation refusée';
        loading = false;
        notifyListeners();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      valueGPS = LatLng(pos.latitude, pos.longitude);
      await _resolveCity(pos.latitude, pos.longitude);
    } catch (_) {
      error = 'Impossible d\'obtenir la position';
    }

    loading = false;
    notifyListeners();
  }

  // ── Résolution ville ─────────────────────────────────────────────────────────

  Future<void> _resolveCity(double lat, double lng) async {
    try {
      final marks = await placemarkFromCoordinates(lat, lng);
      if (marks.isNotEmpty) {
        valueCity = marks.first.locality ?? marks.first.subAdministrativeArea;
      }
    } catch (_) {
      valueCity = null;
    }
  }
}
