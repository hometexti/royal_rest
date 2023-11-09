import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';

class MapWithRoutePage extends StatefulWidget {
  final Map<String, dynamic> data;
  MapWithRoutePage({required this.data});
  @override
  _MapWithRoutePageState createState() => _MapWithRoutePageState();
}

class _MapWithRoutePageState extends State<MapWithRoutePage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  TextEditingController _destinationLatController = TextEditingController();
  TextEditingController _destinationLngController = TextEditingController();
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: 'AIzaSyCN5diDX2775gqDzQPHLFU0Z9Glq2SMwbY');

  @override
  void initState() {
    super.initState();
    // Add your initialization logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.primaryColor1,
          centerTitle: true,
          title: Text(
            "Route",
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
            Expanded(
              child: GoogleMap(
                trafficEnabled: true,
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      (widget.data['lat']),
                      (widget.data[
                          'long'])), // New York City as initial camera position
                  zoom: 12.0,
                ),
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (controller) {
                  _mapController = controller;
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
                _showRoute();
              },
              child: Icon(Icons.route),
            ),
          ),
        ));
  }

  void _showRoute() async {
    try {
      double destinationLat = (widget.data['cus_lat']);

      double destinationLng = (widget.data['cus_long']);

      List<LatLng>? route = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng((widget.data['lat']),
            (widget.data['long'])), // New York City as the starting point
        destination: LatLng(destinationLat, destinationLng),
        mode: RouteMode.driving,
      );

      if (route!.isNotEmpty) {
        setState(() {
          _markers.clear();
          _polylines.clear();
          _polylineCoordinates = route;

          // Add starting point marker
          _markers.add(Marker(
            markerId: MarkerId('start'),
            position: LatLng((widget.data['lat']), (widget.data['long'])),
            infoWindow: InfoWindow(title: 'Start Point'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ));

          // Add destination point marker
          _markers.add(Marker(
            markerId: MarkerId('destination'),
            position: LatLng(destinationLat, destinationLng),
            infoWindow: InfoWindow(title: 'Destination'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));

          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            points: _polylineCoordinates,
            width: 5,
          ));
        });
        print("hereeeeeeeeeeee");
        // Move the camera to show both the starting and destination points

        LatLng latLng = LatLng(destinationLat, destinationLng);
        _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
      } else {
        // Handle error, e.g., show a snackbar with an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unable to find a route.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
