import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/nav_page.dart';

class LocationAccessPage extends StatefulWidget {
  const LocationAccessPage({super.key});

  @override
  State<LocationAccessPage> createState() => _LocationAccessPageState();
}

class _LocationAccessPageState extends State<LocationAccessPage> {
  bool _isLoadingGPS = false;
  bool _isSaving = false;
  String? _detectedCity;

  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isSearching = false;

  final List<String> _popularCities = [
    "New York, USA",
    "Los Angeles, USA",
    "London, UK",
    "Mumbai, India",
    "Delhi, India",
    "Bangalore, India",
    "Toronto, Canada",
    "Dubai, UAE",
    "Sydney, Australia",
    "Singapore",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _isLoadingGPS = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError("Location permission denied");
          setState(() => _isLoadingGPS = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showError("Please enable location in settings");
        setState(() => _isLoadingGPS = false);
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subAdministrativeArea ?? "";
        final country = place.country ?? "";
        final fullLocation = "$city, $country".trim();
        setState(() {
          _detectedCity = fullLocation.isEmpty ? "Unknown Location" : fullLocation;
          _isLoadingGPS = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingGPS = false);
      _showError("Could not detect location. Try manual search.");
    }
  }

  Future<void> _searchCity(String query) async {
    if (query.trim().length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final locations = await locationFromAddress(query);
      final results = <String>{};
      for (final loc in locations.take(5)) {
        final placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final city = p.locality ?? p.subAdministrativeArea ?? "";
          final country = p.country ?? "";
          if (city.isNotEmpty) results.add("$city, $country");
        }
      }
      setState(() {
        _searchResults = results.toList();
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = _popularCities
            .where((c) => c.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _isSearching = false;
      });
    }
  }

  Future<void> _saveAndProceed(String location) async {
    setState(() => _isSaving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'location': location}, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Location save error: $e");
    }
    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NavPage(index: 0)),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on,
                          color: Colors.orange, size: 48),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Center(
                    child: Text(
                      "Your Location",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Set your location to find trainers near you",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500, height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // GPS Button
                  GestureDetector(
                    onTap: _isLoadingGPS ? null : _detectLocation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoadingGPS)
                            const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          else
                            const Icon(Icons.my_location, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            _isLoadingGPS ? "Detecting location..." : "Use Current Location",
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Detected location
                  if (_detectedCity != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(_detectedCity!,
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          ),
                          TextButton(
                            onPressed: _isSaving ? null : () => _saveAndProceed(_detectedCity!),
                            child: const Text("Use this", style: TextStyle(color: Colors.orange)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR SEARCH MANUALLY",
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600, letterSpacing: 1),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchCity,
                      decoration: InputDecoration(
                        hintText: "Search city (e.g. Mumbai, London...)",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Colors.orange),
                        suffixIcon: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(width: 16, height: 16,
                                    child: CircularProgressIndicator(color: Colors.orange, strokeWidth: 2)),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  // Search results
                  if (_searchResults.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: Column(
                        children: _searchResults.map((city) => ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.orange, size: 20),
                          title: Text(city, style: const TextStyle(fontSize: 14)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchResults = []);
                            _saveAndProceed(city);
                          },
                        )).toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Popular cities
                  if (_searchResults.isEmpty) ...[
                    Text(
                      "Popular cities",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _popularCities.map((city) => GestureDetector(
                        onTap: () => _saveAndProceed(city),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_city, size: 14, color: Colors.orange),
                              const SizedBox(width: 6),
                              Text(city.split(",").first, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),

            if (_isSaving)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                ),
              ),
          ],
        ),
      ),
    );
  }
}