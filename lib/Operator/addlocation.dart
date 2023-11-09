import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';

class AddressSearchPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  const AddressSearchPage(
      {super.key, required this.latitude, required this.longitude});
  @override
  _AddressSearchPageState createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late LatLng? _selectedLocation = LatLng(widget.latitude, widget.longitude);
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  void _searchLocation(String searchText) async {
    try {
      List<Location> locations = await locationFromAddress(searchText);

      setState(() {
        _markers.clear();
        if (locations.isNotEmpty) {
          _selectedLocation =
              LatLng(locations.first.latitude, locations.first.longitude);
          _markers.add(
            Marker(
              markerId: MarkerId('pinnedLocation'),
              position: _selectedLocation!,
            ),
          );

          // Update the map's camera position with the selected location

          print(_mapController);
          _mapController
              ?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _selectedLocation!,
                    zoom: 50.0,
                  ),
                ),
              )
              .then((value) {});
        } else {
          _selectedLocation = null;
        }
      });
    } catch (e) {
      print('Error searching address: $e');
    }
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: _selectedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ), // Custom marker icon
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.primaryColor1,
          centerTitle: true,
          title: Text(
            "Search Address",
            style: AppTextStyle.appNameTextStyle,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.linearGradientPrimary,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Address',
                ),
                onChanged: (value) {
                  _searchLocation(value);
                },
              ),
            ),
            if (_selectedLocation != null)
              Expanded(
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  indoorViewEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation!,
                    zoom: 15.0,
                  ),
                  markers: _markers,
                  onTap: _selectLocation,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    print("mappppppppppp created");
                  },
                ),
              ),
          ],
        ),
        floatingActionButton: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                if (_selectedLocation != null) {
                  Map<String, dynamic> data = {
                    "lat": _selectedLocation!.latitude,
                    "long": _selectedLocation!.longitude
                  };
                  Navigator.pop(context, data);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("First find customer address"),
                  ));
                }
              },
              child: Icon(Icons.done_outline),
            ),
          ),
        ));
  }
}
