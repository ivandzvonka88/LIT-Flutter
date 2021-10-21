
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

class CreateLituationPage extends StatefulWidget{
  final LituationVisit lv;
  CreateLituationPage({Key key , this.lv}) : super(key: key);

  @override
  _CreateLituationPageState createState() => new _CreateLituationPageState();

}
class _CreateLituationPageState extends State<CreateLituationPage>{
  TextEditingController inputController;
  TextEditingController titleController;
  TextEditingController feeController;
  TextEditingController capController;
  TextEditingController themesController;
  TextEditingController descriptionController;
  TextEditingController addressController;
  TextEditingController userSearchController;
  String date_error = "";
  bool hasFee = false;
  bool hasCapacity = false;
  List<String> themes = [];
  LituationProvider lp;
  BitmapDescriptor myIcon;
  String location = '';
  LatLng locationLatLng = LatLng(0 , 0);
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  MapType _mapType = MapType.normal;
  String _dateStr = '';
  String _time = '';
  String _end_time = '';
  Lituation newLituation;
  static LatLng _initialPosition =  LatLng(45.521563, -122.677433);
  double zoom = 8.0;
  List<PlacesSearchResult> places = [];
  List<String> addressResults = [];
  GlobalKey<FormState> _formKey =  new GlobalKey<FormState>();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyCjYd92XrLthFK7mvaJ_LPV1iNeurnx9MQ');
  @override
  void dispose(){
    inputController.dispose();
    titleController.dispose();
    feeController.dispose();
    capController.dispose();
    themesController.dispose();
    userSearchController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.dispose();
  }
  void initState(){
    inputController = TextEditingController();
    titleController = TextEditingController();
    feeController = TextEditingController();
    capController = TextEditingController();
    themesController = TextEditingController();
    descriptionController = TextEditingController();
    userSearchController = TextEditingController();
    addressController = TextEditingController();
    newLituation = initNewLituation();
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
        child: createLituationWidget(),
        onWillPop: _onBackPressed,
      ),
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );
  }

  Widget createLituationWidget(){
    String title = widget.lv.lituationName == CREATE_LITUATION_TAG?'New Lituation':'Modify ' + widget.lv.lituationName;
    Color cardBg = Theme.of(context).scaffoldBackgroundColor;
    Color hintColor = Theme.of(context).primaryColor;
    Color textColor = Theme.of(context).textSelectionColor;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: topNav(backButton(), pageTitle(title, Theme.of(context).textSelectionColor), [Container()], Theme.of(context).scaffoldBackgroundColor),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(),
            children: <Widget> [
              Container(child: pageInfoHint('Enter the details of your lituation \nbelow to get started...'),margin: EdgeInsets.only(left: 15 , top: 25 , bottom: 25),),
              editableLituationInfoCard(lituationCardLabel(newLituation.title==null?'Lituation Title: ' :'Lituation Title: ' + newLituation.title, textColor), lituationCardHint('Enter a creative title...', hintColor), titleTextField(widget.lv.lituationID), cardBg),
              editableLituationInfoCard(lituationCardLabel( newLituation.description==null?'Description: ':'Description:', textColor), lituationCardHint('What is your lituation about...', hintColor), descriptionTextField(widget.lv.lituationID), cardBg),
              themesInputTextField(),
              userSearchTextField(),
              locationPicker(),
              galleryWidget(),
              entryPicker(Icons.sensor_door_outlined, 'Entry:' , 'entry'),
              capacityPicker(Icons.people, 'Capacity:' , 'entry'),
              datePicker(Icons.calendar_today_outlined, 'Date:' , showDate(dateHint, _dateStr ),cupertinoDatePicker() , 'Plan a day ahead.'),
              datePicker(Icons.access_time, 'Start Time:' , showDate(startTimeHint, _time) ,cupertinoStartTimePicker() , 'Be ready for show time'),
              datePicker(Icons.cancel, 'End Time:' , showDate(endTimeHint, _end_time) ,cupertinoEndTimePicker() , 'What time is lights out?'),
              showDateOrFeeError(),
              nextButton(context),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      );
  }
  Widget nextButton(BuildContext ctx){
    return Container( //login button
        height: 45,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: RaisedButton(
            color: Theme.of(context).buttonColor,
            textColor: Theme.of(context).primaryColor,
            child: Text('preview' , style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
              nextPage();
            }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        ));
  }
  void nextPage(){
    if(widget.lv.lituationID == CREATE_LITUATION_TAG){
      _formKey.currentState.validate();
      if(lp.validateLituation(newLituation) == 'valid'){
        launchPreview(newLituation ,  CREATE_LITUATION_TAG);
        return;
      } else {
      setState(() {
        date_error = lp.validateLituation(newLituation);
      });
      return;
      }
    } else {
      launchPreview(null, widget.lv.lituationID);
    }
  }

  void launchPreview(Lituation l , String LID){

  }


  Widget showDateOrFeeError(){
    return Container( //login button
      margin: EdgeInsets.fromLTRB(10, 25, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(date_error, style: infoValue(Colors.red),textAlign: TextAlign.center,),
    );
  }
  Widget cupertinoDatePicker(){
    // List<String> capacityOptions = ['N/A','max'];
    if(widget.lv.lituationID == CREATE_LITUATION_TAG){
      return
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 50,
          width: 250,
          child: CupertinoTheme(
            data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(color: Theme.of(context).dividerColor , fontSize: 12 , fontWeight: FontWeight.w400),
                )
            ),
            child: CupertinoDatePicker(
              minimumDate: DateTime.now().add(new Duration(days: 1)),
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now().add(new Duration(days: 2)),
              onDateTimeChanged: (DateTime c) {
                setState(() {
                  newLituation.date = c;
                  _dateStr =  DateFormat.yMEd().format(newLituation.date);
                });
              },
            ),
          )
          ,
        );
    }
    //TODO make fields work with exisiting lituationd raft
  }
  Widget cupertinoStartTimePicker(){
    if(widget.lv.lituationID == CREATE_LITUATION_TAG) {
      return
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 50,
          width: 250,
          child: CupertinoTheme(
            data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(color: Theme
                      .of(context)
                      .dividerColor, fontSize: 12, fontWeight: FontWeight.w400),
                )
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime c) {
                setState(() {
                  if (newLituation.date == null) {
                    _dateStr = 'TBD';
                    date_error = 'select a date first';
                  } else {
                    _time = newLituation.date.hour.toString() + ':' +
                        newLituation.date.minute.toString();
                    DateTime d = DateTime(
                        newLituation.date.year, newLituation.date.month, newLituation.date.day, c.hour,
                        c.minute);
                    newLituation.date = d;
                    _time = DateFormat.jm().format(newLituation.date) + ' (' +
                        newLituation.date.timeZoneName + ')';
                  }
                });
              },
            ),
          )
          ,
        );
    }

  }
  DateTime tommorow(){
    var today = DateTime.now();
    return new DateTime(today.year , today.month , today.day + 1);
  }
  Widget cupertinoEndTimePicker(){
    // List<String> capacityOptions = ['N/A','max'];
    if(widget.lv.lituationID == CREATE_LITUATION_TAG) {
      return
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 50,
          width: 250,
          child: CupertinoTheme(
            data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(color: Theme
                      .of(context)
                      .dividerColor, fontSize: 12, fontWeight: FontWeight.w400),
                )
            ),
            child: CupertinoDatePicker(
              minimumDate: tommorow().add(
                  new Duration(hours: 1, minutes: 0, seconds: 0)),
              mode: CupertinoDatePickerMode.time,
              initialDateTime: tommorow(),
              onDateTimeChanged: (DateTime c) {
                setState(() {
                  if (newLituation.date == null) {
                    _dateStr = 'TBD';
                    date_error = 'select a date first';
                  } else {
                    DateTime d = DateTime(
                        newLituation.date.year, newLituation.date.month, newLituation.date.day, c.hour,
                        c.minute);
                    newLituation.end_date = d;
                    _end_time =
                        DateFormat.jm().format(d) + ' (' + d.timeZoneName + ')';
                  }
                });
              },
            ),
          )
          ,
        );
    }
  }
  Widget showDate(String hint , String date){
    return Container( //login button
      margin: EdgeInsets.fromLTRB(10, 25, 0, 15),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(hint + "\n" + date,
        style: infoLabel(Theme.of(context).textSelectionColor), textAlign: TextAlign.left,),
    );
  }
Widget pageInfoHint(String hint){
    return Text(hint , style: infoLabel(Theme.of(context).textSelectionColor),);
}
  Widget themesInputTextField(){
    return Card(
        elevation: 5,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Themes:' ,style: infoLabel(Theme.of(context).textSelectionColor),),
                themeTextField(widget.lv.userID),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: RichText(text: TextSpan(
                      text: 'Themes:' ,
                      style:  infoValue(Theme.of(context).primaryColor)
                      ,children: [
                    TextSpan(text: newLituation.themes==null?'':'\n\n'+newLituation.themes ,style: infoValue(Theme.of(context).textSelectionColor))
                  ]),),),
              ],
            )
        )
    );
  }
  Widget userSearchTextField(){
    return Card(
        elevation: 5,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invited:' ,style: infoLabel(Theme.of(context).textSelectionColor),),
                inviteTextField(widget.lv.userID),
                invitedGuestList()
              ],
            )
        )
    );
  }
Widget invitedGuestList(){
  return Container(
    margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Invited vibes...", style: infoValue(Theme.of(context).primaryColor),),
        Container(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newLituation.invited.length,
            itemBuilder: (ctx, idx) {
              return invitedCircularProfileWidget(
                  newLituation.invited[idx]);
            },
          ),
        )
      ],
    ),
  );
}
  void _viewProfile(String id , String username){
    UserVisit v = UserVisit();
    v.visitorID = widget.lv.userID;
    v.visitedID = id;
    v.visitNote = username;
    print(v.visitNote);
    Navigator.pushNamed(context, VisitProfilePageRoute , arguments: v);
  }
  Widget invitedCircularProfileWidget(String userID){
    return StreamBuilder(
      stream: lp.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
          onTap: (){
            if(userID !=  widget.lv.userID){
              _viewProfile(userID , user.data['username']);
            }
          },
          child: Container(
              child: Row(
                children: [
                  // approveButton(userID),
                  Column(
                    children: [
                      userProfileThumbnail(user.data['profileURL'] , user.data['status']['status']),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: new Text(user.data['username'],
                            style: Theme.of(context).textTheme.headline3,textAlign: TextAlign.center,textScaleFactor: 0.9,)
                      ),
                    ],
                  ),
                  removeInvitedButton(userID),
                ],
              )
          ),
        );
      },
    );
  }
  Widget removeInvitedButton(String userID){
    return Container(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: (){
            removeInvited(userID);
          },
          child:  Icon(Ionicons.ios_close_circle_outline, size: 20, color: Colors.red,),
        )
    );
  }

  String removeInvited(String id){
    setState(() {
      newLituation.invited.remove(id);
    });
  }
Widget titleTextField(String u){
  if(widget.lv.lituationID == CREATE_LITUATION_TAG){
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      maxLength: 36,
      cursorColor: Theme.of(context).primaryColor,
      controller: titleController,
      style: infoValue(Theme.of(context).textSelectionColor),
      decoration: InputDecoration(
        labelText: "Enter your lituation title",
        hintStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 12 , decoration: TextDecoration.none),
        labelStyle: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 14 ,decoration: TextDecoration.none),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1)),
      ),
      validator: (input) {
        if(input.isEmpty){
          return 'Your title cannot be empty';
        }
        if(input.length < 5){
          return 'Your title is too short';
        }
        return null;
      },
      onChanged: (input){
        _formKey.currentState.save();
        setState(() {
          if(widget.lv.lituationID.contains(CREATE_LITUATION_TAG)){
            newLituation.title = input;
          }
        });
        //descriptionTec.text = input;
      },
    );
  }

  }

  Widget themeTextField(String u){
    return  TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          cursorColor: Theme.of(context).primaryColor,
          controller: themesController,
          autofocus: false,
          style: infoValue(Theme.of(context).textSelectionColor),
          decoration: InputDecoration(
            labelText: "What categories does your lituation fall under?",
            hintText: theme_hint,
            hintStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 12 , decoration: TextDecoration.none),
            labelStyle: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 14 ,decoration: TextDecoration.none),
            border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1)),
            suffixIcon: IconButton(icon: Icon(Icons.add, color: Theme.of(context).primaryColor,),
              onPressed: (){
                setState(() {
                  String _input = themesController.text;
                  if(!themes.contains(_input)){
                    themes.add(_input);
                    newLituation.themes = themes.toString().replaceAll("[", "").replaceAll("]", "");
                    //inputController.text = "";
                  }else if(_input.contains(',')){
                    themes.addAll(_input.toLowerCase().split(','));
                    newLituation.themes =  themes.toString().replaceAll("[", "").replaceAll("]", "");
                  }else{
                    themes.remove(_input);
                    newLituation.themes = themes.toString().replaceAll("[", "").replaceAll("]", "");
                  }
                  themesController.text = '';
                });
              },
            ),

          )
      ),
      suggestionsCallback: (pattern) async {
        return lp.getCategories().then((value){
          return List.from(value.data()['events']).where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        });
      }
      ,
      itemBuilder: (context, suggestion) {
        return Material(
            color: Theme.of(context).backgroundColor,
            child:  lituationCategoryResultTile(suggestion , context)
        );
      },
      onSuggestionSelected: (suggestion) {
        //print(suggestion);
        themesController.text = suggestion;
      },
    );
  }
  Widget inviteTextField(String u){
    return  TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          cursorColor: Theme.of(context).primaryColor,
          controller: userSearchController,
          autofocus: false,
          style: infoValue(Theme.of(context).textSelectionColor),
          decoration: InputDecoration(
            labelText: "Select friends you'd like to invite...",
            hintText: invite_hint,
            hintStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 12 , decoration: TextDecoration.none),
            labelStyle: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 14 ,decoration: TextDecoration.none),
            border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1)),
            suffixIcon: IconButton(icon: Icon(Icons.clear, color: Theme.of(context).primaryColor,),
              onPressed: (){
                setState(() {
                  userSearchController.text = '';
                });
              },
            ),

          )
      ),
      suggestionsCallback: (pattern) async {
        return lp.searchUser(pattern).then((value){
        var results = [];
        for(var u in value){
          if(u.data()['username'].toString().toLowerCase().contains(pattern.toLowerCase())){
            results.add(u);
          }
        }
        return results;
        });
      }
      ,
      itemBuilder: (context, suggestion) {
        return Material(
            color: Theme.of(context).backgroundColor,
            child:  userResultTile(suggestion.data()['username'],suggestion.data()['profileURL'], context)
        );
      },
      onSuggestionSelected: (suggestion) {
        print(suggestion);
        newLituation.invited.add(suggestion.data()['userID']);
        userSearchController.text = suggestion.data()['username'];
      },
      noItemsFoundBuilder: (context){
        return Container();
      },
    );
  }
  Widget descriptionTextField(String u){
    if(widget.lv.lituationID == CREATE_LITUATION_TAG){
      print('slick');
    }
    return TextFormField(
      maxLines: null,
      autofocus: false,
      maxLength: 500,
      cursorColor: Theme.of(context).primaryColor,
      controller: descriptionController,
      style: infoValue(Theme.of(context).textSelectionColor),
      decoration: InputDecoration(
        labelText: "Enter your lituation description...",
        hintStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 12 , decoration: TextDecoration.none),
        labelStyle: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 14 ,decoration: TextDecoration.none),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1)),
      ),
      onChanged: (input){
        _formKey.currentState.save();
       setState(() {
         if(widget.lv.lituationID.contains(CREATE_LITUATION_TAG)){
           newLituation.description = input;
         }
       });
        //descriptionTec.text = input;
      },
      validator: (input) {
        if(input.isEmpty){
          return 'Your description cannot be empty';
        }
        if(input.length < 50){
          return 'Your description is too short. (50+)';
        }
        return null;
      },
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text('Are you sure?' ,style: TextStyle(color: Theme.of(context).buttonColor),),
            content: Text('Do you want to exit LIT?' ,style: TextStyle(color: Theme.of(context).textSelectionColor)),
            actions: <Widget>[
              FlatButton(
                child: Text('No, of course not' ,style: TextStyle(color: Theme.of(context).textSelectionColor)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes, bye' ,style: TextStyle(color: Theme.of(context).textSelectionColor)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  Widget locationPicker(){
    if(widget.lv.lituationID == CREATE_LITUATION_TAG){
      return Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        margin: EdgeInsets.all(5),
        elevation: 3,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showLituationField(newLituation.location==null?'Address: Enter the address for your Lituation':'Address: ' + newLituation.location),
              mapsWidget(),
              addressSearchBar(),
              Padding(padding: EdgeInsets.all(15),)
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget addressSearchBar(){
    return Container(
      margin: EdgeInsets.only(top: 25 , left: 15 , right: 15),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            cursorColor: Theme.of(context).textSelectionColor,
            controller: addressController,
            autofocus: false,
            style: TextStyle(color: Theme.of(context).textSelectionColor),
            decoration: InputDecoration(
                labelText: 'Where should we turn up?',
                hintText: "e.g 123 MyAddress Rd, City 54321, United States",
                hintStyle: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 12 , decoration: TextDecoration.none),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 14 ,decoration: TextDecoration.none),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1),),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2))

            )
        ),
        suggestionsCallback: (pattern) async {
          var locationIcon = await getBytesFromAssetFile('assets/images/litlocationicon.png' ,225);
          return searchAddress(pattern).then((value){
            List<Marker> resultMarkers = [];
            if(value.length > 0) {
              moveCamera(CameraPosition(
                bearing: 0,
                zoom: 16,
                target: LatLng(value[0].geometry.location.lat,
                    value[0].geometry.location.lng),
              ));
              for(PlacesSearchResult place in places){
                LatLng pos = LatLng(place.geometry.location.lat , place.geometry.location.lng);
                resultMarkers.add(googleMapMarker(place.name, BitmapDescriptor.fromBytes(locationIcon), pos));
              }
              drawMarkers(resultMarkers);
            }
            return value;
          });
        }
        ,
        itemBuilder: (context, PlacesSearchResult suggestion) {
          return Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: placeResultTile(context , suggestion)
          );
        },
        onSuggestionSelected: (PlacesSearchResult suggestion) {
          //print(suggestion);
          newLituation.location = suggestion.formattedAddress;
          newLituation.locationLatLng = LatLng(suggestion.geometry.location.lat , suggestion.geometry.location.lng);
          addressController.text = suggestion.name;
          drawMarker(googleMapMarker(suggestion.name, myIcon, LatLng(suggestion.geometry.location.lat , suggestion.geometry.location.lng)));
          moveCamera(CameraPosition(
            bearing: 0,
            zoom: 16,
            target: newLituation.locationLatLng,
          ));
        },
      ),
    );
  }
  Widget datePicker(IconData descIcon , String title , Widget display ,Widget picker , String hint){
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            display,
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
                    child: Icon(descIcon , color: Theme.of(context).primaryColor,)),
                new Container(
                    width: 75,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: new Text(title, style: infoValue(Theme.of(context).textSelectionColor),)),
                new Expanded(
                  //width: 175,
                  child: picker,
                ),
              ],
            ),
            fieldHint(hint),
            Padding( padding: EdgeInsets.fromLTRB(15, 10, 15, 10),)
          ],
        ),
      ),
    );
  }
  Marker googleMapMarker(String title , BitmapDescriptor icon , LatLng pos){
    return Marker(
      markerId: MarkerId(title),
      position: pos,
      icon: icon,
    );
  }
  Future<void> drawMarker(Marker n) async {
    var locationIcon = await getBytesFromAssetFile('assets/images/litlocationicon.png' ,250);
    Marker k = Marker(markerId: n.markerId , position: n.position , icon: BitmapDescriptor.fromBytes(locationIcon));
    setState(() {
      _markers.clear();
      _markers.add(k);
      print(k.markerId);
    });
    return;
  }
  Future<List<PlacesSearchResult>> searchAddress(String query) async {
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
  }
  Future<void> moveCamera(CameraPosition cameraPosition) async {
    final GoogleMapController ctrl = await _controller.future;
    ctrl.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
  Future<void> drawMarkers(List<Marker> newMarkers) async {
    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
    return;
  }
  Widget mapsWidget(){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      height: 250,
      child: GoogleMap(
        markers: _markers,
        mapType: _mapType,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: zoom
        ),
      )
      ,);
  }

  List<Widget> selectedMedia(){
    List<Widget> s = [];
    if(newLituation.thumbnailURLs.isNotEmpty){
      for(int i = 0; i < newLituation.thumbnailURLs.length; i++){
        s.add(galleryPhoto(newLituation.thumbnailURLs[i], i));
      }
    }else{
      for(int i = 0; i < 5; i++){
        s.add(galleryPhoto('', i));
      }
    }
    return s;
  }
  Widget galleryWidget(){
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        height: 285,
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child:Text(select_lituation_media_hint ,style: TextStyle(color: Theme.of(context).textSelectionColor , fontWeight: FontWeight.w700),textAlign: TextAlign.left,), padding: EdgeInsets.fromLTRB(15 , 15 , 0 , 0),
            ),
            Expanded(
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: selectedMedia()
              ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              child:Opacity(
                opacity: 0.8,
                child: Text(remove_lituation_media_tip ,style: TextStyle(color: Theme.of(context).primaryColor , fontWeight: FontWeight.w300 ,fontSize: 12),textAlign: TextAlign.left,),),
              padding: EdgeInsets.fromLTRB(15 , 0 , 0 , 0),
            ),
          ],
        ),
      ),
    );
  }
  Widget mediaSet(String url , File img){
    if(url == null || url.isEmpty){
      return Icon(Icons.add, color: Theme.of(context).primaryColor, size: 150,);
    }else {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(img),
            )
        ),
      );
    }
  }
  Widget galleryPhoto(String url , int pos){
    return Card(
      elevation: 5,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: 150.0,
        height: 150.0,
        child:  Stack(
          children: [
            GestureDetector(
              onLongPress: (){
                if(url != null && url != ""){
                  removeMedia(context , pos);
                }

              },
              onTap:(){selectMedia(context , pos);},
              child:     Opacity(
                opacity: 0.5,
                child: mediaSet(url , new File(url)),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(0, 55, 0, 0),
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: Text(newLituation.title==null?'':newLituation.title, style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 14 ,fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
              alignment: Alignment.center,
              padding: EdgeInsets.all(5.0),
              child: Text(newLituation.entry==null?'':newLituation.entry , style: TextStyle(color: Theme.of(context).dividerColor , fontSize: 10 ,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.bottomCenter,
              child: Text('' , style: TextStyle(color: Theme.of(context).dividerColor , fontSize: 12 ),textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }
  void deleteMedia(pos){
    setState(() {
      newLituation.thumbnailURLs[pos] = null;
    });
  }
  Future<void> selectMedia(BuildContext ctx , int pos){
    return showDialog(context: ctx ,
        builder: (BuildContext){
          return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(select_photo_hint , style: infoLabel(Theme.of(context).primaryColor),),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Text(gallery_hint , style: infoValue(Theme.of(context).textSelectionColor),),
                          onTap:(){
                            _toGallery(ctx , pos);
                          },
                        ),
                        Padding(padding: EdgeInsets.all(10.0),),
                        GestureDetector(
                          child: Text(camera_hint , style: infoValue(Theme.of(context).textSelectionColor),),
                          onTap:(){
                            _takePhoto(ctx , pos);
                          },
                        ),
                      ],
                    ),

                  ],
                ),
              )
          );});
  }


  void _toGallery(BuildContext context , int pos) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedImg = await picker.getImage(source: ImageSource.gallery);
    File newImg = File(pickedImg.path);
    String imgName = newImg.path;
    setState(() {
      newLituation.thumbnailURLs[pos] = imgName;
    });
    Navigator.of(context).pop();
  }
  void _takePhoto(BuildContext context , int pos) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedImg = await picker.getImage(source: ImageSource.camera);
    File newImg = File(pickedImg.path);
    String imgName = newImg.path;
    setState(() {
      newLituation.thumbnailURLs[pos] = imgName;
    });
    Navigator.of(context).pop();
  }
  Future<void> removeMedia(BuildContext ctx , int pos){
    return showDialog(context: ctx ,
        builder: (BuildContext){
          return AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(remove_lituation_media_tip),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Text("Yes" , style: TextStyle(color: Theme.of(context).buttonColor),),
                          onTap:(){
                            deleteMedia(pos);
                            Navigator.pop(context);
                          },
                        ),
                        Padding(padding: EdgeInsets.all(10.0),),
                        GestureDetector(
                          child: Text("No" , style: TextStyle(color: Theme.of(context).buttonColor),),
                          onTap:(){
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),

                  ],
                ),
              )
          );});
  }
  Widget backButton(){
    return GestureDetector(
      onTap: (){Navigator.of(context).pop();},
      child: Icon(Icons.arrow_back , color: Theme.of(context).buttonColor,),
    );
  }

  Widget showLituationField(String field){
    return Container( //login button
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
      child: Text(field,
        style: infoLabel(Theme.of(context).textSelectionColor), textAlign: TextAlign.left,),
    );
  }

  Widget entryPicker(IconData descIcon , String title , String value){
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showLituationField(newLituation.entry==''?'Entry: Is it private? or is there a fee?':'Entry: '+newLituation.entry),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
                    child: Icon(descIcon , color: Theme.of(context).primaryColor,)),
                new Container(
                    width: 75,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: new Text(title, style: infoValue(Theme.of(context).textSelectionColor),)

                ),
                new Expanded(
                  //width: 175,
                  child: entryPickerOptions(),
                ),
                new Expanded(
                  //width: 175,
                  child: feeInput(),
                )
              ],
            ),
            fieldHint(hasFee?'Enter the entry fee amount.':'Select entry requirement.'),
            Padding( padding: EdgeInsets.fromLTRB(15, 10, 15, 10),)
          ],
        ),
      ),
    );
  }

  Widget fieldHint(String hint){
   return Container(
      height: 35,
      width: double.infinity,
      child:Opacity(
        opacity: 0.8,
        child: Text(hint ,style: TextStyle(color: Theme.of(context).primaryColor , fontWeight: FontWeight.w300 ,fontSize: 12),textAlign: TextAlign.left,),),
      padding: EdgeInsets.fromLTRB(15 , 5 , 0 , 0),
    );
  }
  Widget entryPickerOptions(){
    List<String> entryOptions = ['Invite-Only','Open','Fee' , 'Private'];
    return
      CupertinoPicker(
          magnification: 1,
          //backgroundColor: Theme.of(context).primaryColor,
          children: <Widget>[
            pickerButton(entryOptions[0]),
            pickerButton(entryOptions[1]),
            pickerButton(entryOptions[2]),
            pickerButton(entryOptions[3]),
          ],
          itemExtent: 50, //height of each item
          looping: true,
          onSelectedItemChanged: (int index) {
            setState(() {
              date_error = '';
              newLituation.entry  = entryOptions[index];
              if (newLituation.entry .toLowerCase().contains('fee')) {
                hasFee = true;
              } else {
                hasFee = false;
              }
            });
          }
      );
  }
  Widget pickerButton(String val){
    return
      MaterialButton(
        onPressed: (){},
        child: Text(
          val,textAlign: TextAlign.center,
          style: infoValue(Theme.of(context).textSelectionColor),
        ),
      );
  }
  Widget capacityPicker(IconData descIcon , String title , String value){
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showLituationField(newLituation.capacity==''?'Capacity: How many people are you expecting?':'Capacity: ' + newLituation.capacity),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Icon(descIcon , color: Theme.of(context).primaryColor,)),
                new Container(
                    width: 75,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: new Text(title, style: infoValue(Theme.of(context).textSelectionColor),)),
                new Expanded(
                  //width: 175,
                  child: capacityPickerOptions(),
                ),
                new Expanded(
                  //width: 175,
                  child: capacityInput(),
                )
              ],
            ),
            fieldHint(hasCapacity?'How many people are you expecting?':'N/A if there is no capacity.'),
            Padding( padding: EdgeInsets.fromLTRB(15, 10, 15, 10),)
          ],
        ),
      ),
    );
  }

  Widget capacityPickerOptions(){
    List<String> capacityOptions = ['N/A','max'];
    return
      CupertinoPicker(
          magnification: 1,
          //backgroundColor: Theme.of(context).primaryColor,
          children: <Widget>[
            pickerButton(capacityOptions[0]),
            pickerButton(capacityOptions[1]),
          ],
          itemExtent: 50, //height of each item
          looping: true,
          onSelectedItemChanged: (int index) {
            setState(() {
              newLituation.capacity = capacityOptions[index];
              if(newLituation.capacity.toLowerCase().contains('max')){
                hasCapacity = true;
              }else{
                hasCapacity = false;
              }
            });
          }
      );
  }
  Widget capacityInput() {
    if (hasCapacity) {
      return Container(
        margin: EdgeInsets.fromLTRB(5, 15, 15, 0),
        child: TextFormField(
          controller: capController,
          maxLengthEnforced: true,
          textAlign: TextAlign.center,
          validator: (input) {
            if (input.trim().isEmpty) {
              return 'please enter a valid number';
            }
            if (input == '0') {
              return 'set to N/A';
            }
            return null;
          },
          onChanged: (input) {
            setState(() {
              newLituation.capacity = input;
              _formKey.currentState.save();
            });
          },
          keyboardType: TextInputType.number,
          onSaved: (input) => newLituation.capacity = input,
          maxLines: 1,
          minLines: 1,
          maxLength: 9,
          style: TextStyle(color: Theme.of(context).textSelectionColor),
          cursorColor: Theme.of(context).buttonColor,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.person , color: Theme.of(context).primaryColor,),
              labelText: capacity_hint,
              labelStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 14 , fontWeight: FontWeight.w900),
          ),
        ),
      );
    }else{
      return Container();
    }
  }
  Widget feeInput() {
    if (hasFee) {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: TextFormField(
          controller: feeController,
          maxLengthEnforced: true,
          textAlign: TextAlign.center,
          validator: (input) {
            if (input
                .trim()
                .isEmpty) {
              return 'please enter a valid amound';
            }
            if (input == '0') {
              return 'change your entry to \'Open\'';
            }
            return null;
          },
          onChanged: (input) {
            setState(() {
              newLituation.fee = input;
              _formKey.currentState.save();
            });
          },
          keyboardType: TextInputType.number,
          onSaved: (input) => newLituation.fee = input,
          maxLines: 1,
          minLines: 1,
          maxLength: 5,
          style: TextStyle(color: Theme.of(context).textSelectionColor),
          cursorColor: Theme.of(context).textSelectionColor,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.attach_money , color: Theme.of(context).primaryColor,),
              labelText: fee_hint,
              labelStyle: TextStyle(color: Theme.of(context).primaryColor , fontSize: 12),
          ),
        ),
      );
    }else{
      return Container();
    }
  }

  Lituation initNewLituation(){
    Lituation l = new Lituation();
    l.capacity = 'N/A';
    l.date = DateTime.now();
    l.end_date = DateTime.now();
    l.dateCreated = DateTime.now();
    l.description = '';
    l.title = '';
    l.entry = 'Open';
    l.hostID = widget.lv.userID;
    l.eventID = widget.lv.lituationID;
    l.fee = 'free';
    l.location = '';
    l.locationLatLng = new LatLng(0, 0);
    l.musicGenres = [];
    l.requirements = [];
    l.themes = '';
    l.status = 'New';
    l.clout = 0;
    l.specialGuests = [];
    l.invited = [];
    l.observers = [];
    l.vibes = [];
    l.thumbnailURLs = [];

    return l;
  }
}