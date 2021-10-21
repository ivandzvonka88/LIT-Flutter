
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

Future<String> geocodeAddressFromLatLng(LatLng loc) async {
  final coords = new Coordinates(loc.latitude, loc.longitude);
  var res = await Geocoder.local.findAddressesFromCoordinates(coords);
  var first = res.first;
  List n = List.from(first.addressLine.split(','));
  n.removeAt(0);
  return n.toString().replaceAll('[', '').replaceAll(']', '');
}

Future<Uint8List> getBytesFromAssetFile(String path , int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  return( await frameInfo.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}

/*Future<List<PlacesSearchResult>> searchAddress(String query) async {
  final result = await _places.searchByText(query);
  _markers.clear();
  addressResults.clear();
  if(result.status == "OK"){
    places = result.results;
    result.results.forEach((a){
      print(a.formattedAddress);
    });
  }else{
    print(result.status);
  }
  return places;
}*/