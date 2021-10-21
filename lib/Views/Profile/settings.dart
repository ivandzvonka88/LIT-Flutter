
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_context/dialog_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:lit_beta/Extensions/common_functions.dart';
import 'package:lit_beta/Extensions/common_maps_functions.dart';
import 'package:lit_beta/Extensions/common_widgets.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Providers/ProfileProvider/profile_provider.dart';
import 'package:lit_beta/Strings/constants.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Strings/settings.dart';
import 'package:lit_beta/Styles/app_themes.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:lit_beta/Styles/theme_provider.dart';
import 'package:lit_beta/Utils/SharedPrefsHelper.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

import 'package:lit_beta/Styles/theme_resolver.dart';

class SettingsPage extends StatefulWidget {
  final String userID;
  SettingsPage({Key key , this.userID}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage>{

  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController preferenceController;
  TextEditingController attendancePreferenceController;
  TextEditingController userLocationController;
  List<String> preferences = [];
  String selectedPreferences = '';
  TextEditingController descriptionTec;
  ProfileProvider provider;
  bool edit = false;
  bool adult_lituations = false;
  bool vibe_notifs = false;
  bool lituation_notifs = false;
  bool invitation_notifs = false;
  bool general_notifs = false;
  String error = '';

  String location = '';
  LatLng locationLatLng = LatLng(0 , 0);
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  MapType _mapType = MapType.normal;
  static LatLng _initialPosition =  LatLng(45.521563, -122.677433);
  double zoom = 8.0;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentTheme = 0;
  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    initTheme();
    usernameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    preferenceController = TextEditingController();
    attendancePreferenceController = TextEditingController();
    userLocationController = TextEditingController();
    provider = ProfileProvider(widget.userID);
    getUserLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
     if(_controller.isCompleted){
       _controller.complete(controller);
     }
  }

  @override
  Widget build(BuildContext context) {
        return settingsWidget();
  }
  void initTheme(){
    HelperExtension.getUserThemeSharedPrefs().then((value) => {
    setState(() {
    switch (value) {
    case 'light':
    currentTheme = 0;
    break;
    case 'dark':
    currentTheme = 1;
    break;
    case 'auto':
    currentTheme = 2;
    break;
    default:
    currentTheme = 0;
    break;
    }
    print('theme is: ' + currentTheme.toString());
    })
    });
  }
  String parseThemeIndex(int id){
    switch (id) {
      case 0:
        return 'light';
      case 1:
        return 'dark';
      case 2:
        return 'auto';
      default:
        return 'auto';
    }
  }
  Widget settingsWidget(){
    if(widget.userID == null){
      return Container();
    }
    return StreamBuilder(
      stream: provider.userStream(),
      builder: (context , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return Scaffold(
            key: _scaffoldKey,
          appBar: topNav(backButton(), pageTitle('Settings', Theme.of(context).textSelectionColor), [editButton()], Theme.of(context).scaffoldBackgroundColor),
          backgroundColor: Theme.of(context).backgroundColor,
          body: settingsProvider(user)
        );
      },
    );
  }

  Widget settingsProvider(AsyncSnapshot user){
    String profileUrl = user.data['profileURL'];
    String username = user.data['username'];
    String email = user.data['email'];
    String vibePreference = user.data['userVibe']['lituationPrefs'];
    String vibeLocation = user.data['userLocation'];
    String vibeAttendancePreference = user.data['userVibe']['preference'];

    Color tc = Theme.of(context).textSelectionColor;
    Color btnC = Theme.of(context).primaryColor;
    Color labelCol = Theme.of(context).textSelectionColor;
    Color  bg = Theme.of(context).scaffoldBackgroundColor;
    if(!edit){
      return ListView(
        children: [
          infoSectionHeader(info_general_hint, labelCol),
          horizontalDivider(Theme.of(context).dividerColor, MediaQuery.of(context).size.width),
          infoCard(info_username_hint, username, FontAwesome5.smile, bg , btnC , tc),//text field
          infoCard(info_email_hint, email, FontAwesome5.envelope, bg , btnC , tc),//text field
          infoCard(info_password_hint, '**********', FontAwesome.lock, bg , btnC , tc), //reset button

          infoSectionHeader(info_vibe_hint, labelCol),
          horizontalDivider(Theme.of(context).dividerColor, MediaQuery.of(context).size.width),
          infoCard(info_preference_hint, vibePreference==''?'(update your preferences...)':vibePreference, FontAwesome5.image, bg , btnC , tc), ////typeahead field
          infoCard(info_attendance_hint, vibeAttendancePreference, FontAwesome.sticky_note, bg , btnC , tc), //drop down
          mapsWidget(user),
          infoSectionHeader('Lituations', labelCol),
          _userSettingsProvider(),
        ],
      );
    }

    //editables
    return ListView(
      children: [
        infoSectionHeader(info_general_hint, labelCol),
        horizontalDivider(Theme.of(context).dividerColor, MediaQuery.of(context).size.width),
       editableInfoCard(Text('Change Username...' ,style: infoLabel(btnC),) , usernameTextField(user) , bg),
       editableInfoCard(Text('Change Email...' ,style: infoLabel(btnC),) , emailTextField(user) , bg),
        changePasswordField(),

        infoSectionHeader(info_vibe_hint, labelCol),
        horizontalDivider(Theme.of(context).dividerColor, MediaQuery.of(context).size.width),
        preferenceInputTextField(user),
        attendancePreferenceDropdown(user),

        mapsWidget(user),
        getLocationButtonWidget(),
        _userSettingsProvider(),
      ],
    );
  }

  Widget usernameTextField(AsyncSnapshot u){
    if(usernameController != null && usernameController.text == ''){
      usernameController.text = u.data['username'];
    }
    return TextField(
      maxLines: null,
      autofocus: false,
      maxLength: 16,
      cursorColor: Theme.of(context).buttonColor,
      controller: usernameController,
      style: infoValue(Theme.of(context).textSelectionColor),
      onChanged: (input){
        //descriptionTec.text = input;
      },
    );
  }
  Widget emailTextField(AsyncSnapshot u){
    if(emailController != null && emailController.text == ''){
      emailController.text = u.data['email'];
    }
    return TextField(
      maxLines: null,
      autofocus: false,
      maxLength: 75,
      cursorColor: Theme.of(context).buttonColor,
      controller: emailController,
      style: infoValue(Theme.of(context).textSelectionColor),
      onChanged: (input){
        //descriptionTec.text = input;
      },
    );
  }

  Widget attendancePreferenceDropdown(AsyncSnapshot u){
    String attendancePref = u.data["userVibe"]["preference"]==''?'Host':u.data["userVibe"]["preference"];
    return Card(
      elevation: 5,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New attendance preference:' ,style: infoLabel(Theme.of(context).primaryColor),),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: DropdownButton(
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                value: attendancePref,
                items: [
                  DropdownMenuItem(
                    child: Text("Host", style: infoValue(Theme.of(context).textSelectionColor)),
                    value: 'Host',
                  ),
                  DropdownMenuItem(
                    child: Text("Attend", style: infoValue(Theme.of(context).textSelectionColor)),
                    value: 'Attend',
                  ),
                  DropdownMenuItem(
                      child: Text("Host & Attend", style: infoValue(Theme.of(context).textSelectionColor)),
                      value: 'Host & Attend'
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    attendancePref = value;
                    provider.updateAttendancePreference(value);
                  });
                }),
          ),
          ],
        ),
      ),
    );
  }

  Widget privacyPickerDropdown(String val , String settingName){
    String privacy_setting = val==''?'PUBLIC':val;
    String title = settingName.replaceFirst('_' , ' ');
    return Card(
      elevation: 5,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New ' + title,style: infoLabel(Theme.of(context).primaryColor),),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: DropdownButton(
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  value: privacy_setting,
                  items: [
                    DropdownMenuItem(
                      child: Text("Public", style: infoValue(Theme.of(context).textSelectionColor)),
                      value: 'PUBLIC',
                    ),
                    DropdownMenuItem(
                      child: Text("Private", style: infoValue(Theme.of(context).textSelectionColor)),
                      value: 'PRIVATE',
                    ),
                    DropdownMenuItem(
                        child: Text("Hidden", style: infoValue(Theme.of(context).textSelectionColor)),
                        value: 'HIDDEN'
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      privacy_setting = value;
                      updatePrivacySetting(settingName, value);
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLocationButtonWidget(){
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
    try {
      final GoogleMapController ctrl = await _controller.future;
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true).catchError((err) => print(err));
      final Uint8List locationIcon = await getBytesFromAssetFile(
          'assets/images/litlocationicon.png', 250);
      setState(() {
        _markers.clear();
        _markers.add(
            Marker(
                markerId: MarkerId('It\'s lit'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.fromBytes(locationIcon)
        )
        );
      });
      _initialPosition = LatLng(position.latitude, position.longitude);
      ctrl.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: _initialPosition,
            zoom: 16.0,
          )
      ));
      geocodeAddressFromLatLng(LatLng(position.latitude, position.longitude))
          .then((value) {
        setState(() {
          location = value;
          locationLatLng = LatLng(position.latitude, position.longitude);
        });
      });
      print(location);
      provider.updateUserLocation(location, locationLatLng);
      //provider.updateUserLocation(location, locationLatLng);
    }catch (e){
      print(e.toString());
    }
  }

  Widget themePickerDropdown(String initialValue){
    return Card(
      elevation: 5,
      color: Theme.of(context).backgroundColor,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set Theme:',style: infoLabel(Theme.of(context).primaryColor),),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: DropdownButton(
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  value: currentTheme,
                  items: [
                    DropdownMenuItem(
                      child: Text("light" , style: infoValue(Theme.of(context).textSelectionColor),),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text("dark", style: infoValue(Theme.of(context).textSelectionColor)),
                      value: 1,
                    ),
                    DropdownMenuItem(
                        child: Text("auto", style: infoValue(Theme.of(context).textSelectionColor)),
                        value: 2
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      changeTheme(value);
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void changeTheme(int v){
    final themeNotifier = Provider.of<ThemeNotifier>(context , listen: false);
    setState(() {
      currentTheme = v;
      switch(v){
        case 0:
          onThemeChanged(0, themeNotifier);
          break;
        case 1:
          onThemeChanged(1, themeNotifier);
          break;
        default:
          onThemeChanged(0, themeNotifier);
          break;

      }
    });
  }
  void onThemeChanged(int value, ThemeNotifier themeNotifier) async {
    String theme;
    switch(value){
      case 0:
        currentTheme = 0;
        theme = 'light';
        themeNotifier.setTheme(t1);
        break;
      case 1:
        currentTheme = 1;
        theme = 'dark';
        themeNotifier.setTheme(t2);
        break;
      case 2:
        currentTheme = 2;;
        theme = 'auto';
        themeNotifier.setTheme(hourCheck());
        break;
      default:
        currentTheme = 0;
        theme = 'light';
        themeNotifier.setTheme(t1);
        break;
    }
    HelperExtension.saveUserThemeSharedPrefs(theme);
  }
  ThemeData hourCheck() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return t1;
    }
    if (hour < 17) {
      return t2;
    }
    return t1;
  }
  void updatePrivacySetting(String settingName ,  String newValue){
    switch(settingName){
      case db_user_setting_vibe:
        provider.updateVibeVisibility(newValue);
        break;
      case db_user_setting_lituation:
        provider.updateLituationsVisibility(newValue);
        break;

      case db_user_setting_activity:
        provider.updateActivityVisibility(newValue);
        break;

      case db_user_setting_location:
        provider.updateLocationVisibility(newValue);
        break;
    }
  }

  Widget changePasswordField(){
    return Card(
      color: Theme.of(context).buttonColor,
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 25 , right: 25),
        height: 35,
        child: FlatButton(
          color: Theme.of(context).buttonColor,
          child: Text('change password' , style: TextStyle(color: Theme.of(context).textSelectionColor),),
          onPressed: (){
            //TODO Implement password reset process
          },
        )
      ),
    );
  }
  Widget preferenceInputTextField(AsyncSnapshot u){
    return Card(
      elevation: 5,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New lituation preferences:' ,style: infoLabel(Theme.of(context).primaryColor),),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  cursorColor: Theme.of(context).textSelectionColor,
                  controller: preferenceController,
                  autofocus: false,
                  style: TextStyle(color: Theme.of(context).textSelectionColor),
                  decoration: InputDecoration(
                    labelText: theme_preference_hint,
                    hintText: theme_label,
                    hintStyle: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 12 , decoration: TextDecoration.none),
                    labelStyle: TextStyle(color: Theme.of(context).textSelectionColor , fontSize: 14 ,decoration: TextDecoration.none),
                    suffixIcon: IconButton(icon: Icon(Icons.add, color: Theme.of(context).textSelectionColor,),
                      onPressed: (){
                        setState(() {
                          String _input = preferenceController.text;
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
                          preferenceController.text = '';
                        });
                      },
                    ),

                  )
              ),
              suggestionsCallback: (pattern) async {
                return [];
                //TODO Connect To preferences tab
                /*return db.getLituationCategories().then((value) {
          return List.from(value.data()['events']).where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        });
*/
              }
              ,
              itemBuilder: (context, suggestion) {
                return Material(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Image.asset('assets/images/litlogo.png'),
                      title: Text(suggestion , style: TextStyle(color: Theme.of(context).buttonColor , decoration: TextDecoration.none),),
                    )
                );
              },
              onSuggestionSelected: (suggestion) {
                //print(suggestion);
                //TODO Update preference
                preferenceController.text = suggestion;
                //provider.updateAttendancePreference(val);
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: RichText(text: TextSpan(
                text: 'I like' ,
                style:  infoValue(Theme.of(context).primaryColor)
            ,children: [
              TextSpan(text: '\n\n' +  u.data['userVibe']['lituationPrefs'] ,style: infoValue(Theme.of(context).textSelectionColor))
            ]),),),
          ],
        )
      )
    );
  }
  Widget backButton(){
    return GestureDetector(
      onTap: (){Navigator.of(context).pop();},
      child: Icon(Icons.arrow_back , color: Theme.of(context).buttonColor,),
    );
  }

  //TODO Remove
  Widget adminResetSettingButton(){
    return Container(
      margin: EdgeInsets.only(right: 15, top: 15 , bottom: 10),
      child: FlatButton(
          color: edit?Colors.green:Theme.of(context).backgroundColor,
          onPressed: (){
            setState(() {
              provider.resetUserSettingsToDefault();
            });
          },
          child: Text("RESET" ,textScaleFactor: 0.9,),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
      ),
    );
  }


  Widget editButton(){
    return Container(
      margin: EdgeInsets.only(right: 15, top: 15 , bottom: 10),
      child: FlatButton(
          color: edit?Colors.green:Theme.of(context).buttonColor,
          onPressed: (){
            if(edit){
              save();
            }else {
              edit = !edit;
            }
            setState(() {});
          },
          child: Text(edit?'save':'edit' ,style: infoValue(Theme.of(context).textSelectionColor) ,textScaleFactor: 0.9,),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
      ),
    );
  }
  void save(){
    if(usernameController.text != '' && usernameController.text.length > 8){
      provider.updateUsername(usernameController.text);
    }
    edit = !edit;
  }
  Widget _userSettingsProvider(){
    Color tc = Theme.of(context).textSelectionColor;
    Color btnC = Theme.of(context).primaryColor;
    Color labelCol = Theme.of(context).textSelectionColor;
    Color  bg = Theme.of(context).scaffoldBackgroundColor;
    return StreamBuilder(
      stream: provider.userSettingsStream(),
      builder: (context, s){
        if(!s.hasData){
          return CircularProgressIndicator();
        }
        if(s.connectionState == ConnectionState.waiting){
          return Container();
        }

        print(PrivacySettings.PRIVATE);
        String _settingVibeVisibilty = s.data[db_user_setting_vibe] == ''?PrivacySettings.PRIVATE:s.data["vibe_visibility"];
        String _settingLituationVisibilty = s.data[db_user_setting_lituation] == ''?PrivacySettings.PRIVATE:s.data["vibe_visibility"];
        String _settingActivityVisibilty = s.data[db_user_setting_activity] == ''?PrivacySettings.PRIVATE:s.data["vibe_visibility"];
        String _settingLocationVisibilty = s.data[db_user_setting_location] == ''?PrivacySettings.PRIVATE:s.data["vibe_visibility"];
        bool invitation_notifications = s.data[db_user_setting_invitation_notifications];
        bool lituation_notifications = s.data[db_user_setting_lituation_notifications];
        bool general_notifications = s.data[db_user_setting_general_notifications];
        bool chat_notifications = s.data[db_user_setting_chat_notifications];
        bool vibe_notifications = s.data[db_user_setting_vibe_notifications];
        bool adult_lituations =  s.data[db_user_setting_adult_lituations];
        String theme = s.data[db_user_setting_theme];

        if(!edit) {
          return Column(
            children: [
              infoCard(adult_lituations_hint, adult_lituations?'enabled':'disabled',
                  FontAwesome5.question_circle, bg, btnC, tc),
              infoCard(
                  setting_invitation_notifications_hint, invitation_notifications?'enabled':'disabled',
                  FontAwesome5.question_circle, bg, btnC, tc),
              infoCard(
                  setting_lituation_notifications_hint, lituation_notifications?'enabled':'disabled',
                  FontAwesome5.question_circle, bg, btnC, tc),
              infoSectionHeader('Notifications', labelCol),
              horizontalDivider(Theme
                  .of(context)
                  .dividerColor, MediaQuery
                  .of(context)
                  .size
                  .width),
              infoCard(setting_vibe_notifications_hint, vibe_notifications?'enabled':'disabled',
                  FontAwesome5.question_circle, bg, btnC, tc),
              infoCard(
                  setting_chat_notifications_hint, chat_notifications?'enabled':'disabled',
                  FontAwesome5.question_circle, bg, btnC, tc),
              infoCard(setting_general_notifications_hint, general_notifications?'enabled':'disabled',
                  FontAwesome5.question_circle, bg, btnC, tc),
              infoSectionHeader('Profile Privacy',labelCol),
              horizontalDivider(Theme
                  .of(context)
                  .dividerColor, MediaQuery
                  .of(context)
                  .size
                  .width),
              infoCard(info_vibe_visibilty_hint, _settingVibeVisibilty,
                  FontAwesome5.question_circle, bg, btnC, tc), //drop down
              infoCard(
                  info_litations_visibilty_hint, _settingLituationVisibilty,
                  FontAwesome5.question_circle, bg, btnC, tc), //drop down
              infoCard(info_activity_visibilty_hint, _settingActivityVisibilty,
                  FontAwesome5.question_circle, bg, btnC, tc), //drop down
              infoCard(info_location_visibilty_hint, _settingLocationVisibilty,
                  FontAwesome5.question_circle, bg, btnC, tc), //drop down
              infoSectionHeader('Theme', labelCol),
              horizontalDivider(Theme.of(context).dividerColor, MediaQuery.of(context).size.width),
              infoCard(info_theme_hint, theme, FontAwesome.paint_brush, bg , btnC , tc),
            ],
          );
        }
        return Column(
          children: [
            settingCardSwitch(adult_lituations_hint,
                adult_lituations ? 'enabled' : 'disabled', settingSwitchAdultLituations(adult_lituations),
                bg, btnC, tc), //drop down
            settingCardSwitch(setting_invitation_notifications_hint,
                invitation_notifications ? 'enabled' : 'disabled',
                settingSwitchInvitation(invitation_notifications), bg, btnC, tc),
            settingCardSwitch(setting_lituation_notifications_hint,
                lituation_notifications ? 'enabled' : 'disabled',
                settingSwitchLituation(lituation_notifications), bg, btnC, tc),
            infoSectionHeader('Update Notification Settings', labelCol),
            horizontalDivider(Theme
                .of(context)
                .dividerColor, MediaQuery
                .of(context)
                .size
                .width),
            settingCardSwitch(setting_vibe_notifications_hint,
                vibe_notifications ? 'enabled' : 'disabled',
                settingSwitchVibe(vibe_notifications), bg, btnC, tc), //drop down
            settingCardSwitch(setting_chat_notifications_hint,
                chat_notifications ? 'enabled' : 'disabled',
                settingSwitchChat(chat_notifications), bg, btnC, tc), //drop down
            settingCardSwitch(setting_general_notifications_hint,
                general_notifications ? 'enabled' : 'disabled',
                settingSwitchGeneral(general_notifications), bg, btnC, tc), //drop down

            infoSectionHeader('Update Profile Privacy Settings', labelCol),
            horizontalDivider(Theme
                .of(context)
                .dividerColor, MediaQuery
                .of(context)
                .size
                .width),
            privacyPickerDropdown(s.data[db_user_setting_vibe] , db_user_setting_vibe), //drop down
            privacyPickerDropdown(s.data[db_user_setting_lituation] , db_user_setting_lituation),//drop down
            privacyPickerDropdown(s.data[db_user_setting_activity] , db_user_setting_activity), //drop down
            privacyPickerDropdown(s.data[db_user_setting_location] , db_user_setting_location), //drop down
            infoSectionHeader('Theme', labelCol),
            horizontalDivider(Theme.of(context).dividerColor, MediaQuery.of(context).size.width),
            themePickerDropdown(theme)//drop down
          ],
        );
      },
    );
  }

  Widget mapsWidget(AsyncSnapshot u){
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
            target:  latLngFromGeoPoint(u.data["userLocLatLng"]),
            zoom: zoom
        ),
      )
      ,);
  }

  LatLng latLngFromGeoPoint(GeoPoint gp){
    LatLng l = new LatLng(gp.latitude, gp.longitude);
    return l;
  }
  Widget settingSwitchVibe(bool val){
    return Switch(
      onChanged: toggleVibeNotifications,
      value: val,
      activeColor: Colors.green,
      activeTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.redAccent,
      inactiveTrackColor: Colors.orange,
    );
  }
  Widget settingSwitchLituation(bool val){
    return Switch(
      onChanged: toggleLituationNotifications,
      value: val,
      activeColor: Colors.green,
      activeTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.redAccent,
      inactiveTrackColor: Colors.orange,
    );
  }
  Widget settingSwitchAdultLituations(bool val){
    return Switch(
      onChanged: toggleAdultLituation,
      value: val,
      activeColor: Colors.green,
      activeTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.redAccent,
      inactiveTrackColor: Colors.orange,
    );
  }
  Widget settingSwitchInvitation(bool val){
    return Switch(
      onChanged: toggleInvitationNotifications,
      value: val,
      activeColor: Colors.green,
      activeTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.redAccent,
      inactiveTrackColor: Colors.orange,
    );
  }
  Widget settingSwitchGeneral(bool val){
    return Switch(
      onChanged: toggleGeneralNotifications,
      value: val,
      activeColor: Colors.green,
      activeTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.redAccent,
      inactiveTrackColor: Colors.orange,
    );
  }
  Widget settingSwitchChat(bool val){
    return Switch(
      onChanged: toggleChatNotifications,
      value: val,
      activeColor: Colors.green,
      activeTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.redAccent,
      inactiveTrackColor: Colors.orange,
    );
  }
  void toggleAdultLituation(bool val){
  provider.updateShowAdultLituations(val);
  }
  void toggleInvitationNotifications(bool val){
    provider.updateInvitationNotifications(val);
  }
  void toggleLituationNotifications(bool val){
    provider.updateLituationNotifications(val);
  }

  void toggleVibeNotifications(bool val){
    provider.updateVibeNotifications(val);
  }
  void toggleChatNotifications(bool val){
    provider.updateChatNotifications(val);
  }
  void toggleGeneralNotifications(bool val){
    provider.updateGeneralNotifications(val);
  }
}
