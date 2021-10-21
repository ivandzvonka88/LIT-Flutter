
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lit_beta/Extensions/common_maps_functions.dart';
import 'package:lit_beta/Extensions/common_widgets.dart';
import 'package:lit_beta/Models/Lituation.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Providers/ProfileProvider/lituation_provider.dart';
import 'package:lit_beta/Strings/constants.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Styles/text_styles.dart';

class PreviewLituationPage extends StatefulWidget{
  final LituationVisit lv;
  PreviewLituationPage({Key key , this.lv}) : super(key: key);

  @override
  _PreviewLituationPageState createState() => new _PreviewLituationPageState();

}
class _PreviewLituationPageState extends State<PreviewLituationPage>{
  LituationProvider lp;
  static LatLng _initialPosition =  LatLng(45.521563, -122.677433);
  double zoom = 8.0;
  List<PlacesSearchResult> places = [];
  Completer<GoogleMapController> _controller = Completer();
  List<String> addressResults = [];
  GlobalKey<FormState> _formKey =  new GlobalKey<FormState>();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyCjYd92XrLthFK7mvaJ_LPV1iNeurnx9MQ');
  @override
  void dispose(){
    super.dispose();
  }
  void initState(){
    lp = LituationProvider(widget.lv.lituationID , widget.lv.userID);
    super.initState();
  }
  void _onMapCreated(GoogleMapController controller) {
    if(!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: WillPopScope(
        child: previewLituationWidget(),
        //onWillPop: _onBackPressed,
      ),
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );
  }

Widget previewLituationWidget(){

}
}