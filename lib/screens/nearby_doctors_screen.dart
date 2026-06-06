import 'package:dermai/resources.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyDoctorsScreen extends StatefulWidget {
  const NearbyDoctorsScreen({Key? key}) : super(key: key);

  @override
  State<NearbyDoctorsScreen> createState() => _NearbyDoctorsScreenState();
}

class _NearbyDoctorsScreenState extends State<NearbyDoctorsScreen> {
  GoogleMapController? _mapController;
  Position? _position;
  String _status = 'locating';  // locating | ready | denied
  Set<Marker> _markers = {};

  static const double _defaultLat = 17.3850;  // Hyderabad fallback
  static const double _defaultLng = 78.4867;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        setState(() => _status = 'denied');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _position = pos;
        _status = 'ready';
        _markers = {
          Marker(
            markerId: const MarkerId('me'),
            position: LatLng(pos.latitude, pos.longitude),
            infoWindow: const InfoWindow(title: 'You are here'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        };
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(pos.latitude, pos.longitude), 14));
    } catch (_) {
      setState(() => _status = 'ready');  // show map with default location
    }
  }

  void _searchOnMaps() async {
    final lat = _position?.latitude ?? _defaultLat;
    final lng = _position?.longitude ?? _defaultLng;
    final uri = Uri.parse(
        'https://www.google.com/maps/search/dermatologist/@$lat,$lng,14z');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = _position?.latitude ?? _defaultLat;
    final lng = _position?.longitude ?? _defaultLng;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Nearby Dermatologists',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(children: [
        // Map
        Expanded(
          flex: 3,
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 14),
              onMapCreated: (ctrl) => _mapController = ctrl,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
            if (_status == 'locating')
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(child: CircularProgressIndicator(color: c)),
              ),
            if (_status == 'denied')
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.location_off_rounded, size: 48, color: Colors.black38),
                    const SizedBox(height: 12),
                    const Text('Location permission denied',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                    const SizedBox(height: 8),
                    const Text('Please enable location in Settings to find nearby doctors.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black38)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: c, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                      onPressed: () => Geolocator.openAppSettings(),
                      child: const Text('Open Settings'),
                    ),
                  ]),
                ),
              ),
            // Recenter button
            Positioned(
              right: 16, bottom: 16,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                onPressed: _getLocation,
                child: const Icon(Icons.my_location_rounded, color: c),
              ),
            ),
          ]),
        ),

        // Bottom panel
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Find a Dermatologist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(_status == 'locating'
                ? 'Getting your location...'
                : _position != null
                    ? 'Searching near your current location'
                    : 'Using default location — enable GPS for better results',
                style: const TextStyle(fontSize: 12, color: Colors.black45)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.search_rounded,
                  label: 'Search on Google Maps',
                  onTap: _searchOnMaps,
                  primary: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  icon: Icons.local_hospital_outlined,
                  label: 'Find Skin Clinics',
                  onTap: () async {
                    final lat2 = _position?.latitude ?? _defaultLat;
                    final lng2 = _position?.longitude ?? _defaultLng;
                    final uri = Uri.parse(
                        'https://www.google.com/maps/search/skin+clinic/@$lat2,$lng2,14z');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  primary: false,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline_rounded, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(child: Text(
                  'Always consult a certified dermatologist for a professional diagnosis. DermAI is a screening tool only.',
                  style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.5),
                )),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _actionButton({
    required IconData icon, required String label,
    required VoidCallback onTap, required bool primary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: primary ? c : const Color(0xFFF0FFF6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary ? c : c.withOpacity(0.3)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: primary ? Colors.white : c),
          const SizedBox(width: 6),
          Flexible(child: Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: primary ? Colors.white : c),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}
