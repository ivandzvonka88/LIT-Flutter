
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lit_beta/Extensions/common_maps_functions.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Providers/AuthProvider/survey_provider.dart';
import 'package:lit_beta/Strings/constants.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:lit_beta/Styles/theme_resolver.dart';
import 'package:lit_beta/Extensions/common_widgets.dart';
class SurveyPage extends StatefulWidget {
  SurveyPage({Key key , this.userID}) : super(key: key);
  final String userID;
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<SurveyPage> {

  SurveyProvider sp;
  int currentIdx = 0;
  String birthdayStr = 'M/D/YYYY';
  DateTime birthday;
  String error = '';
  String gender = '';
  String age = '';
  TextEditingController preferenceInputController;
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  MapType _mapType = MapType.normal;
  static LatLng _initialPosition =  LatLng(45.521563, -122.677433);
  double zoom = 8.0;
  String selectedPreferences = '';
  String attendancePreference = '';
  String location = '';
  LatLng locationLatLng = LatLng(0 , 0);
  List<String> preferences = [];
  List<String> genders = ['swipe up or down','male' , 'female' , 'non-binary'];
  List<String> attendancePreferences = ['Host & Attend' , 'Host' , 'Attend'];

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    sp = SurveyProvider(widget.userID);
    preferenceInputController = new TextEditingController();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    if(!_controller.isCompleted){
      _controller.complete(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return surveyWidget();
  }

  Widget surveyWidget(){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: surveyIndexedStackProvider(),
    );
  }

  bool validator(int page){
    switch(page){
      case 0:
        return birthdayValidator();
        break;
      case 1:
        return themePreferenceValidator();
        break;
      case 2:
        return genderValidator();
        break;
      case 3:
        return preferenceValidator();
        break;
      case 4:
        return locationValidator();
        break;

    }
  }

  bool birthdayValidator(){
    if(birthdayStr != "" && !birthdayStr.contains('M/D/YYYY')) {
      if(!userOfAge(birthday)){
        setState(() {
          error = 'You must be 16 or older\nto use LIT.';
        });
        return false;
      }else {
        sp.updateUserBirthday(birthdayStr);
        return true;
      }
    }else{
     setState(() {
       error = 'select your birthday.';
     });
      return false;
    }
  }
  bool themePreferenceValidator(){
    sp.updateUserThemePreference(selectedPreferences);
    return true;
  }
  bool genderValidator(){
      if (gender != "" && !gender.contains("select")) {
        sp.updateUserGender(gender);
       return true;
      }else{
        setState(() {
          error = "Please select your gender";
        });
        return false;
      }
  }
  bool preferenceValidator(){
    if (attendancePreference != "") {
      sp.updateUserPreference(attendancePreference);
      return true;
    }else{
        setState(() {
          error = "Please select your preference";
        });
        return false;
    }
  }
  bool locationValidator(){
      if (location != "") {
        sp.updateUserLocation(location, locationLatLng);
        return true;
      }else{
        setState(() {
          error = "We need your location to find nearby Lituations.";
        });
        return false;
      }
  }

  Widget nextButton(int page){
    return Container( //login button
        height: 45,
        width: 75,
        child: RaisedButton(
            color: Theme.of(context).buttonColor,
            child: Text('next' , style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
              if (validator(page)){
                setState(() {
                  error = '';
                  _nextPage();
                });
              }
            }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }

  Widget submitButton(){
    return Container( //login button
        margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
        height: 45,
        child: RaisedButton(
            color: Theme.of(context).buttonColor,
            child: Text(submit_label , style: TextStyle(color: Theme.of(context).textSelectionColor),),
            onPressed: (){
             //TODO Show welcome to Lit for a few seconds then to home
              completeRegister();
            }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }

  Widget prevButton(int page){
    return Container( //login button
        height: 45,
        width: 75,
        child: RaisedButton(
            color: Theme.of(context).buttonColor,
            child: Text('prev' , style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
             _prevPage();
            }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }

  Widget nextAndPrevButtonsWidget(int page){
    return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prevButton(page),
          Padding(padding: EdgeInsets.only(left: 25 , right: 25),),
          nextButton(page),

        ],
    );
  }
  Widget logoWidget(){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Image.asset('assets/images/litlogo.png'), height: 150,
    );
  }

  void completeRegister(){
    Navigator.pushReplacementNamed(context, HomePageRoute , arguments: widget.userID);
  }

  Widget hintPrompt(String prompt){
  return  Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
    child: Text(prompt, textAlign: TextAlign.center,style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20 , fontWeight: FontWeight.w600 , fontFamily: 'Itim-Regular'),textScaleFactor: 1.1,),
  );
  }
  Widget errorPrompt(String error){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Text(error, style: TextStyle(color: Colors.red, fontSize: 14),textAlign: TextAlign.center,),
    );
  }
  Widget surveyIndexedStackProvider(){
    return IndexedStack(
      index: currentIdx,
      children: <Widget>[
       birthdayTab(),
       preferencesTab(),
       genderTab(),
       attendancePreferenceTab(),
       locationTab()
      ],
    );

  }
  Widget birthdayTab(){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
          child: ListView(
            children: [
              logoWidget(),
              hintPrompt(birthday_hint),
              Container(
                margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                height: 100,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(color: Theme.of(context).textSelectionColor, fontSize: 18),
                      )
                  ),
                  child:    CupertinoDatePicker(
                    maximumDate: DateTime.now(),
                    minimumDate: DateTime(1900 , 1 , 1),
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime(1990, 1, 1 ,),
                    onDateTimeChanged: (DateTime c) {
                      setState(() {
                        birthdayStr = c.month.toString() + "/" + c.day.toString() + "/" + c.year.toString();
                        birthday = c;
                      });
                    },
                  ),
                )
                ,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(0, 25, 0, 10),
                child: Text(birthdayStr, style: TextStyle(color: Theme.of(context).textSelectionColor, fontSize: 18),),
              ),
              errorPrompt(error),
              nextButton(birthday_page_idx),
            ],
          )
      ),
    );
  }

  Widget preferencesTab(){
    String why = 'Select up to 5 categories';
    String label = selectedPreferences==''?why:'I like ...';
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
            children: [
              logoWidget(),
              hintPrompt(theme_preference_hint),
              preferenceInputTextField(),
              //TODO Show hint
              //Text('to remove a category, re enter it' , style: infoValue(Theme.of(context).textSelectionColor),),
              multiLinePrompt(label, selectedPreferences),
              nextAndPrevButtonsWidget(category_preference_page_idx),
            ],
          )
    );
  }
  Widget genderTab(){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
            children: [
              Padding(padding: EdgeInsets.all(25)),
              logoWidget(),
              hintPrompt(gender_hint),
              pickerWidget(genders , 'gender'),
              Padding(padding: EdgeInsets.all(25)),
              errorPrompt(error),
              nextAndPrevButtonsWidget(gender_page_idx)
            ],
          )
    );
  }

  Widget attendancePreferenceTab(){
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(
          children: [
            Padding(padding: EdgeInsets.all(25)),
            logoWidget(),
            hintPrompt(preference_hint),
            pickerWidget(attendancePreferences , 'preference'),
            Padding(padding: EdgeInsets.all(25)),
            errorPrompt(error),
            nextAndPrevButtonsWidget(preference_page_idx)
          ],
        )
    );
  }
  Widget locationTab(){
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(
          children: [
            Padding(padding: EdgeInsets.all(25)),
            logoWidget(),
            hintPrompt(location_hint),
            mapWidget(),
            getLocationButtonWiget(),
            Padding(padding: EdgeInsets.all(25)),
            submitButton()
          ],
        )
    );
  }

  Widget mapWidget(){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 350,
      width: 300,
      child: GoogleMap(
        markers: _markers,
        mapType: _mapType,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 7
        ),
      )
      ,);
  }

  Widget getLocationButtonWiget(){
      return Container( //login button
          margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
          height: 45,
          child: RaisedButton(
              color: Theme.of(context).buttonColor,
              child: Text('get my location' , style: infoValue(Theme.of(context).textSelectionColor),),
              onPressed: () async {
             await getUserLocation().then((value) =>     print('location is' + _initialPosition.latitude.toString()));
              }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
          )
      );
  }

  Future<void> getUserLocation() async {
    final GoogleMapController ctrl = await _controller.future;
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high , forceAndroidLocationManager: true).catchError((err) => print(err));
    final Uint8List locationIcon = await getBytesFromAssetFile('assets/images/litlocationicon.png' ,250);
    setState(() {
      _markers.clear();
      _markers.add(Marker(markerId: MarkerId('It\'s lit') ,
          position: LatLng(position.latitude , position.longitude),
          icon: BitmapDescriptor.fromBytes(locationIcon)
      )
      );
    _initialPosition = LatLng(position.latitude , position.longitude);
    ctrl.animateCamera(
        CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: _initialPosition,
          zoom: 16.0,
        )
    ));
    });
    geocodeAddressFromLatLng(LatLng(position.latitude , position.longitude)).then((value){
      setState(() {
        location = value;
        locationLatLng =  LatLng(position.latitude , position.longitude);
      });
    });
  }

  Widget pickerWidget(List<String> options, String variable){
    List<Widget> optionsWidgets = [];
    for(String o in options){
      optionsWidgets.add(pickerOption(o));
    }
    return Container(
      child: CupertinoPicker(
        magnification: 1.4,
        backgroundColor: Theme.of(context).backgroundColor,
        children: optionsWidgets,
        itemExtent: 45, //height of each item
        looping: true,
        onSelectedItemChanged: (int index) {
          setState(() {
            pickerUpdate(variable , options[index]);
          });
        },
      )
    );
  }

  void pickerUpdate(String variable , String update){
    if(variable.contains('gender')){
      this.gender = update;
    }
    if(variable.contains('preference')){
      this.attendancePreference = update;
    }
  }
  Widget pickerOption(String val){
    return
      MaterialButton(
        onPressed: (){},
        child: Text(
          val,textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
      );
  }
  Widget multiLinePrompt(String first , String second){
    return Container(
      margin: EdgeInsets.all(50),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(text: '$first\n\n' , style: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 18),
        children: <InlineSpan>[
          TextSpan(text: second ,style: TextStyle(color: Theme.of(context).textSelectionColor, fontSize: 20))
            ]
        ),
      ),
    );
  }

  Widget preferenceInputTextField(){
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          cursorColor: Theme.of(context).primaryColor,
          controller: preferenceInputController,
          autofocus: true,
          style: TextStyle(color: Theme.of(context).textSelectionColor),
          decoration: InputDecoration(
            labelText: theme_preference_hint,
            hintText: theme_label,
            hintStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 12 , decoration: TextDecoration.none),
            labelStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 14 ,decoration: TextDecoration.none),
            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).buttonColor)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1)),
            suffixIcon: IconButton(icon: Icon(Icons.add, color: Theme.of(context).primaryColor,),
              onPressed: (){
                setState(() {
                 String _input = preferenceInputController.text;
                  if(_input == "" || _input.length < 3){
                    error = 'enter a valid event';
                  }else if(!preferences.contains(_input)){
                    preferences.add(_input);
                    selectedPreferences = preferences.toString().replaceAll("[", "").replaceAll("]", "");
                  }else if(_input.contains(',')){
                    preferences.addAll(_input.toLowerCase().split(','));
                    selectedPreferences =  preferences.toString().replaceAll("[", "").replaceAll("]", "");
                  }else{
                    preferences.remove(_input);
                    selectedPreferences = preferences.toString().replaceAll("[", "").replaceAll("]", "");
                  }
                  preferenceInputController.text = '';
                });
              },
            ),

          )
      ),
      suggestionsCallback: (pattern) async {
        return sp.getCategories().then((value){
          return List.from(value.data()['events']).where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        });
      }
      ,
      itemBuilder: (context, suggestion) {
        return Material(
            color: Theme.of(context).backgroundColor,
            child: lituationCategoryResultTile(suggestion , context)
        );
      },
      onSuggestionSelected: (suggestion) {
        //print(suggestion);
        preferenceInputController.text = suggestion;
      },
    );
  }


  void _nextPage(){
    if(currentIdx < 4){
      setState(() {
        print(currentIdx);
        currentIdx++;
      });
    }
  }

  void _prevPage(){
    if(currentIdx > 0){
      setState(() {
        currentIdx--;
      });
    }
  }
  bool userOfAge(DateTime bday){
    bool ofAge = false;
    DateTime today = DateTime.now();
    int age = today.year - bday.year;

    if(age < 16){
      ofAge = false;
    }else{
      ofAge = true;
    }
    return ofAge;
  }
  Widget birthdaySurvey(){
      return Container(color: Colors.blueAccent,);
  }

}
