
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_context/dialog_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:lit_beta/Extensions/common_functions.dart';
import 'package:lit_beta/Extensions/common_widgets.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Providers/ProfileProvider/profile_provider.dart';
import 'package:lit_beta/Strings/constants.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:path/path.dart' as Path;

import 'package:lit_beta/Styles/theme_resolver.dart';

class ProfilePage extends StatefulWidget {
  final String userID;
  ProfilePage({Key key , this.userID}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>{

  bool editBio = false;
  bool hideUpcomingList = false;
  bool hideObservedList = false;
  bool hidePastList = false;
  bool hideDraftsList = false;
  int activityNotificationsTotalCount;
  int vibeNotificationCount;
  int invitationNotificationCount;
  int lituationNotificationCount;

  String selectedFilter = activity_vibe_tab_label;
  List<String> activityFilters = [activity_vibe_tab_label , activity_lituation_tab_label , activity_invitation_tab_label];
  TextEditingController descriptionTec;
  ProfileProvider provider;
  int _tabIdx = 0;

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    provider = ProfileProvider(widget.userID);
    activityNotificationsTotalCount = 0;
    vibeNotificationCount = 0;
    invitationNotificationCount = 0;
    lituationNotificationCount = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return profileWidget(context);

  }

  void initDesc(AsyncSnapshot u){
    if(descriptionTec == null){
      descriptionTec = new TextEditingController(text: u.data['userVibe']['bio']);
      print('initialized');
    }
  }
  //Silverbar usage
  Widget profileWidget(BuildContext c){
    if(widget.userID == null){
      return Container();
    }
    return StreamBuilder(
     stream: provider.userStream(),
      builder: (context , u){
       if(!u.hasData){
         return Container();
       }
       String username = u.data['username'];
       String profileUrl = u.data['profileURL'];
       String clout = u.data['userVibe']['clout'];

       print(profileUrl);
       return Scaffold(
         appBar: topNav(Container(), userThumbnailAppbar(profileUrl), [settingsButton()], Theme.of(context).scaffoldBackgroundColor),
         backgroundColor: Theme.of(context).backgroundColor,
         body: SingleChildScrollView(
           padding: EdgeInsets.all(0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               profileBackground(profileUrl , username),
              statsRow(getUserStats(clout)),
               profileIndexedStackProvider(c, u)
             ],
           ),
         ),
       );
      },
    );
  }

  Widget profileBackground(String url , String username){
    int flexy = 0;
    if(flexy == 0) {
      return Container(
        height: 275,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
                        fit: BoxFit.cover)),
                height: 225,
              )
            ),
            Positioned(
              left: 25,
              bottom: -25,
              child: userThumbnailRow(url, username),
            )
          ],
        ),
      );
    }
    return Container(
      color: Colors.red,
      height: 230,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Stack(
        children: [
          userThumbnail(url, username),
        ],
      ),
    );
  }
  Widget settingsButton(){
    return  Container(
      padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
      child:  IconButton(
        splashRadius: 25,
        splashColor: Theme.of(context).splashColor,
        icon: Icon(Icons.settings,color: Theme.of(context).buttonColor,size: 35,
        ),
        onPressed: (){openSettings();},
      ),
    ) ;
  }
  void openSettings(){
    Navigator.pushNamed(context, SettingsPageRoute , arguments: widget.userID);
  }
  List<Widget> getUserStats(String clout){
    List<Widget> s = [];
    s.add(vibingTabProvider());
    s.add(divider(Theme.of(context).textSelectionColor));
    s.add(cloutTabProvider(clout));
    s.add(divider(Theme.of(context).textSelectionColor));
    s.add(vibedTabProvider());
    return s;
  }

  profileIndexedStackProvider(BuildContext c , AsyncSnapshot u){
    return Column(
      children: [
        indexedStackTabBar(),
        indexedStack(c , u)
      ],
    );
  }

  Widget indexedStack(BuildContext c ,AsyncSnapshot u){
    return IndexedStack(
      index: _tabIdx,
      children: [
        userVibeTab(u),
        userLituationTab(u , c),
        userActivityTab(c , u),

        //aboutList(u),
        //viewUserLituation(u , context),
        //activityList(u)
      ],
    );
  }

  //takes in context and user stream
  Widget userActivityTab(BuildContext c , AsyncSnapshot u){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      activityFilterRow(),
      userActivitySelectionProvider(),
      ],
    );

  }
  Widget userVibeTab(AsyncSnapshot u){
    Color  bg = Theme.of(context).scaffoldBackgroundColor;
    Color btnC = Theme.of(context).primaryColor;
    Color textCol = Theme.of(context).textSelectionColor;
    String email = u.data['email'];
    String username = u.data['username'].toString();
    String gender = u.data["userVibe"]["gender"];
    String birthday = u.data["userVibe"]["birthday"];
    String prefs = u.data["userVibe"]["preference"];
    String lituations = u.data["userVibe"]["lituationPrefs"];
    String location = u.data["userLocation"];
    return Column(
      children: [
        infoSectionHeader(info_about_hint + u.data['username'], Theme.of(context).textSelectionColor),
        userBioProvider(u),
        infoCard(info_email_hint, email, Icons.email, bg , btnC , textCol),
        infoCard(info_username_hint, username, Icons.title, bg , btnC , textCol),
        infoCard(info_gender_hint, gender, Icons.all_inclusive, bg , btnC , textCol),
        infoCard(info_birthday_hint, birthday, Icons.cake, bg , btnC , textCol),
        infoSectionHeader(username + '\'s vibe', Theme.of(context).textSelectionColor),
        infoCard(info_attendance_hint, prefs, Icons.email, bg , btnC , textCol),
        infoCard(info_preference_hint, lituations==''?update_hint:lituations, Ionicons.ios_heart, bg , btnC , textCol),
        infoCard(info_location_hint, location==''?update_hint:location, Icons.my_location, bg , btnC , textCol),
        logoutButton()
      ],
    );
  }

  Widget userLituationTab(AsyncSnapshot u , BuildContext c){
    Color  bg = Theme.of(context).scaffoldBackgroundColor;
    Color btnC = Theme.of(context).primaryColor;
    Color textCol = Theme.of(context).textSelectionColor;
    String email = u.data['email'];
    String username = u.data['username'];

    return StreamBuilder(
      stream: provider.userLituationsStream(),
      builder: (context, userLituations){
        if(!userLituations.hasData || userLituations.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        return Column(
          children: [
            createLituationButton(),
            infoSectionHeader(username+'\'s Lituations', Theme.of(context).textSelectionColor),
            lituationList(c, username, 'upcoming lituations', userLituations.data['upcomingLituations']),
            lituationList(c, username,'pending lituations', userLituations.data['pendingLituations']),
            lituationList(c, username,'past lituations', userLituations.data['pastLituations']),
            lituationList(c, username,'draft lituations', userLituations.data['drafts']),
            lituationList(c, username,'watched lituations', userLituations.data['observedLituations']),
          ],
        );
      }
    );
  }

  Widget removeLituationButton(String lID, String listName){
    return StreamBuilder(
      stream: provider.getLituationStream(lID),
      builder: (context , lituation){
      if(!lituation.hasData) {
        return Container();
      }
      if(lituation.connectionState == ConnectionState.waiting){
        return CircularProgressIndicator();
      }
      print(lituation.data['hostID']);
      if(lituation.data['hostID'].toString().contains(widget.userID)){
        return Container();
      }else{
        return GestureDetector(
          child: Container(
            child: Icon(Icons.cancel_outlined , color: Colors.red,),
          ),
          onTap: (){
            handleRemoveLituation(lID, listName);
          },
        );
      }
      },
    );
  }
  void handleRemoveLituation(String lID , String listName){
    showConfirmationDialog(context , 'Remove' , 'are you sure?' , [confirmRemoveLituationButton(lID ,listName) , cancelDialogButton()]);
  }

  Widget confirmRemoveLituationButton(String lID, String listName){
      return FlatButton(
        child: Text('remove'),
        onPressed: (){
          print(listName);
          provider.removeLituation(lID, listName);
          Navigator.pop(context);
          },
      );
  }
  Widget cancelDialogButton(){
    return FlatButton(
      child: Text('cancel'),
      onPressed: (){ Navigator.pop(context);},
    );
  }
  //we have list of ids,
  Widget lituationList(BuildContext c, String username ,String listname , List lituationIDs){
    Color bg = Theme.of(context).textSelectionColor;
      return Card(
        elevation: 3,
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.all(5.0),
            height: 250,
            child: StreamBuilder<QuerySnapshot>(
                stream: provider.allLituationsStream(), //db.getLituations
                builder: (ctx , lituations){
                  if(!lituations.hasData){
                    return CircularProgressIndicator();
                  }
                  List lList = List.from(lituations.data.docs);
                  List data = List();
                  List<Widget> removeButtons = [];
                  for(var l in lList){
                    if(lituationIDs.contains(l.id.toString())){
                      data.add(l);
                      removeButtons.add(removeLituationButton(l.id.toString(), listname));
                    }
                  }
                  if(data.length > 0) {
                    return viewList(c , data , removeButtons,listname , bg);
                  }
                  return nullList(username, listname , bg);
                }
            )
        ),
      );
  }
  Widget userBioProvider(AsyncSnapshot u){
    initDesc(u);
    if(!editBio){
      return bioCard(bioLabelWidget(u.data['username'] , editButton()), Text(u.data['userVibe']['bio'] , style: infoValue(Theme.of(context).textSelectionColor),), Theme.of(context).scaffoldBackgroundColor);
    }
    return editableBioCard(bioLabelWidget(u.data['username'] , saveButton()), bioTextField(u), Theme.of(context).scaffoldBackgroundColor);
  }

  List<Widget> bioLabelWidget(String username , Widget button){
    List<Widget> w = [];
    w.add(Text(username +'\'s bio' ,style: infoLabel(Theme.of(context).primaryColor),));
    w.add(button);
    return w;
  }

  Widget bioTextField(AsyncSnapshot u){
    return TextField(
      maxLines: null,
      autofocus: false,
      maxLength: 500,
      cursorColor: Theme.of(context).buttonColor,
      controller: descriptionTec,
      style: infoValue(Theme.of(context).textSelectionColor),
      onChanged: (input){
        //descriptionTec.text = input;
      },
    );
  }
  Widget editButton(){
    return GestureDetector(
      onTap: editDesc,
      child: Container(
        height: 35,
        padding: EdgeInsets.fromLTRB(0 , 0 , 0 , 0),
        margin: EdgeInsets.fromLTRB(0 ,0 , 5 , 5),
        child:Icon(Icons.edit, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget saveButton(){
     return GestureDetector(
      onTap: saveDesc,
      child: Container(
        height: 35,
        padding: EdgeInsets.fromLTRB(0 , 0 , 0 , 0),
        margin: EdgeInsets.fromLTRB(0 ,0 , 5 , 5),
        child:Icon(Icons.check, color: Colors.green),
      ),
    );
  }

  void editDesc(){
    setState(() {
      editBio = !editBio;
    });
    return;
  }

  void saveDesc(){
    if(editBio) {
      if(validDescription(descriptionTec.text)){
        provider.updateUserBio(descriptionTec.text).then((value){
          setState(() {
            editBio = false;
          });
        });
      }
      return;
    }
  }

  bool validDescription(String desc){
    if(desc != null)
      return true;
    return false;
  }

  Widget indexedStackTabBar(){
    return Container(
      height: 75,
      margin: EdgeInsets.only(top: 25 , left: 50 , right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: GestureDetector(
                onTap:(){
                  if(_tabIdx != 0) {
                    setState(() {
                      _tabIdx = 0;
                    });
                  }
                },
                //TODO Replace with vibe icon
              child: indexedStackTab(vibe_label, Icons.person , 0),
              )
          ),
          Expanded(
              child: GestureDetector(
                onTap:(){
                  if(_tabIdx != 1) {
                    setState(() {
                      _tabIdx = 1;
                    });
                  }
                },
                //TODO Replace with lituation icon
                child: indexedStackTab(lituation_label, Icons.location_on_rounded , 1),
              )
          )
          ,
          Expanded(
              child: GestureDetector(
                onTap:(){
                  if(_tabIdx != 2) {
                    setState(() {
                      _tabIdx = 2;
                    });
                  }
                },
                //TODO Replace with activity icon
                child: indexedStackTab(activity_label, Ionicons.ios_notifications , 2),
              )
          ),
        ],
      ),
    );
  }

  Widget indexedStackTab(String title ,IconData icon , int idx){
    Color c = Theme.of(context).textSelectionColor;
    Color tc = Theme.of(context).buttonColor;
    Widget indicator = Container();
    if(idx == _tabIdx){
      c = Theme.of(context).primaryColor;
      tc = Theme.of(context).textSelectionColor;
      indicator = selectedIndicator(tc);
    }
    return Container(
      height: 75,
      child: Column(
        children: [
          Expanded(child: Icon(icon , color: c, size: 35,),),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                    title ,
                    style: TextStyle(color: tc),
                    textAlign: TextAlign.center),)
          ),
          indicator
        ],
      ),
    );
  }
  Widget logoutButton(){
    return Container(
        height: 50,
        width: 175,
        margin: EdgeInsets.only(top: 25 , bottom: 25),
        child: RaisedButton(
            child: Text(logout_label ,style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
              provider.logoutUser();
              Navigator.pushReplacementNamed(context, MainPageRoute);
            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }
  Widget createLituationButton(){
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 25 , bottom: 5 , left: 15 , right: 15),
        child: RaisedButton(
            child: Text(create_lituation_label ,style: infoValue(Theme.of(context).textSelectionColor)),
            onPressed: (){
              LituationVisit lv = LituationVisit();
              lv.userID = widget.userID;
              lv.lituationID = CREATE_LITUATION_TAG;
              lv.lituationName = CREATE_LITUATION_TAG;
             Navigator.pushNamed(context, CreateLituationPageRoute , arguments: lv);
            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }
  Widget vibingTabProvider(){
    return StreamBuilder(
        stream: provider.vibingStream(),
        builder: (context , v){
          if(!v.hasData || v.connectionState == ConnectionState.waiting){
            return statsRowTab(vibed_label, CircularProgressIndicator());
          }
          String vibing = parseVibes(List.from(v.data['vibing']).length.toString());
          return GestureDetector(
            child: statsRowTab(vibing_label, statData(vibing)),
            onTap: (){
              _viewMyVibes('vibing');
            },
          );
        }

    );
  }
  Widget cloutTabProvider(String clout){
    return GestureDetector(
      //TODO add clout icon
      child: statsRowTab(clout_label, statData(clout)),
      onTap: (){
        //TODO Show clout description
      },
    );
  }
  Widget vibedTabProvider(){
    return StreamBuilder(
        stream: provider.vibedStream(),
        builder: (context , v){
          if(!v.hasData || v.connectionState == ConnectionState.waiting){
           return statsRowTab(vibed_label, CircularProgressIndicator());
          }
          String vibed = parseVibes(List.from(v.data['vibed']).length.toString());
          return GestureDetector(
            child: statsRowTab(vibed_label, statData(vibed)),
            onTap: (){
              _viewMyVibes('vibed');
            },
          );
        }

    );
  }

  void _viewMyVibes(String note){
    UserVisit v = UserVisit(visitedID: widget.userID ,visitorID:widget.userID, visitNote: note);
    Navigator.of(context).pushNamed(VibesPageRoute , arguments: v);
  }
  Widget statIcon(IconData ic){
    return Icon(ic , color: Theme.of(context).primaryColor,);
  }
  Widget statData(String val){
    return Text(val , style: infoValue(Theme.of(context).primaryColor),textScaleFactor: 1.2,);
  }
  Widget statsRow(List<Widget> stats){
    return Container(
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats
      ),
    );
  }

  Widget statsRowTab(String stat, Widget data){
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Expanded(child: data ,),
          Padding(padding: EdgeInsets.all(5)),
          Expanded(child: Text(stat , style: TextStyle(color: Theme.of(context).textSelectionColor), textScaleFactor: 1,),),
        ],
      ),
    );
  }

  Widget userThumbnailRow(String url , String username){
    return Stack(
      children: [
        Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                GestureDetector(
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: url,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).splashColor),),
                    errorWidget: (context, url, error) => Container(),
                  ),
                  onTap: (){
                    //TODO Allow user change picture on tap
                    changeProfileDialog(context , url);
                  },
                ),
                Container(
                  height: 50,
                  child: Text(username , style: infoLabel(Theme.of(context).textSelectionColor),),
                ),
              ],
            )
        )
      ],
    );

  }
  Widget userThumbnail(String url , String username){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Container(
      height: 200,
      width: 150,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 25),
              child:  GestureDetector(
                child: Icon(Icons.add_a_photo , color: Theme.of(context).buttonColor, size: 25,),
                onTap: (){
                  //TODO Allow user change picture on tap
                  changeProfileDialog(context , url);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  height: 150,
                  width: 150,
                  imageUrl: url,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).splashColor),),
                  errorWidget: (context, url, error) => Container(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: usernameWidget(username),
                )
              ],
            )
          )
        ],
      ),
    )
      ],
    );
  }

  Future<void> changeProfileDialog(BuildContext ctx , String oldImg){
    return showDialog(context: ctx ,
        builder: (BuildContext){
          return AlertDialog(
              title: Text(select_photo_hint),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Text(gallery_hint , style: TextStyle(color: Theme.of(context).buttonColor),),
                          onTap:(){
                            _openGallery(ctx , oldImg);
                          },
                        ),
                        Padding(padding: EdgeInsets.all(10.0),),
                        GestureDetector(
                          child: Text(camera_hint , style: TextStyle(color: Theme.of(context).buttonColor),),
                          onTap:(){
                            _openCamera();
                          },
                        ),
                      ],
                    ),

                  ],
                ),
              )
          );});
  }

  void _openCamera(){
    ImagePickers.openCamera().then((Media media){
      if(media != null){
        provider.updateUserProfileImage(File(media.path));
      }
      showSnackBar(context, sBar('nice...uploading'));
      Navigator.pop(context);
    });
  }
  Future<void> _openGallery(BuildContext context , String oldImage) async {
    List<Media> paths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showGif: false,
        showCamera: true,
        compressSize: 500,
        uiConfig: UIConfig(uiThemeColor: Theme.of(context).backgroundColor),
        cropConfig: CropConfig(enableCrop: false, width: 2, height: 1));
    if(paths.isNotEmpty){
      provider.updateUserProfileImage(File(paths[0].path));
    }
    showSnackBar(context, sBar('nice...uploading'));
    Navigator.pop(context);
  }

  SnackBar sBar(String text){
    return SnackBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Text(text , style: TextStyle(color: Theme.of(context).textSelectionColor),));
  }


  Widget usernameWidget(String val){
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Text(val ,  style: infoLabel(Theme.of(context).textSelectionColor), textScaleFactor: 1.2,),
    );
  }

  Widget activityFilterRow(){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('showing activity for ' , style: infoLabel(Theme.of(context).textSelectionColor),),
            new Container(
              padding: new EdgeInsets.all(5.0),
            ),
            activityDropDownMenu()
          ],
        )
    );
  }
  userActivitySelectionProvider(){
    if(selectedFilter == activityFilters[0]){
      return activityVibeNotificationProvider();
    }
    if(selectedFilter == activityFilters[1]){
      return lituationNotificationsWidget();
    }
    return activityLituationInvitationProvider();
  }
  Widget activityDropDownMenu(){
    return Container(
      child: DropdownButton<String>(
        value: selectedFilter,
        items: activityFilters.map((String e){ return new DropdownMenuItem(child: Text(e ,style: infoValue(Theme.of(context).textSelectionColor),) , value: e,);}).toList(),
        onChanged: (val){
          setState(() {
            selectedFilter = val;
          });
        },
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      )
    );
  }
  DropdownMenuItem<String> activityTabOption(String val){
    return DropdownMenuItem(
      child: Text(val),
      value: val,
    );
  }
  Widget activityVibeNotificationProvider(){
    Widget divider = horizontalDivider(Theme.of(context).dividerColor, MediaQuery.of(context).size.width);
    return Column(
      children: [
        divider,
        pendingVibedRequestList(),
        divider,
        pendingVibingRequestList()
      ],
    );
  }
  Widget activityLituationInvitationProvider(){
    return StreamBuilder(
      stream: provider.userLituationsStream(),
      builder: (context , ul){
        if(!ul.hasData){
          return Container();
        }
        if(ul.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        List<String> invitationIds = List.from(ul.data['invitations']);
        if(invitationIds.isNotEmpty){
          return Column(
            children: [
              horizontalDivider(Theme.of(context).dividerColor, 250),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 25),
                child: Text('there are no invitations' , textAlign: TextAlign.center, style: infoLabel(Theme.of(context).textSelectionColor)),
              ),
              horizontalDivider(Theme.of(context).dividerColor, 250),
            ],
          );
        }
        List<Widget> cards = [];
        List<String> added = [];
        var split;
        for(String id in invitationIds){
          if(!added.contains(id)) {
            invitationNotificationCount++;
            split = id.split(':');
            added.add(id);
            cards.add(lituationInvitationCard(split[0], split[1]));
          }
        }
        return Column(
          children: cards
        );
      },
    );
  }


  Widget lituationInvitationCard(String userID , String lID){
    String message = 'is inviting you';
    List<Widget> acceptOrDecline = [Expanded(flex: 3,child: invitationAcceptButton(userID, lID)),Expanded(flex: 1,child: invitationDeclineButton(userID, lID)) ];
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5,
      child: Container(
        height: 250,
        child: Column(
          children: [
            Expanded(flex: 2,child: lituationThumbnailWidget(lID),),
            Expanded(flex: 1,child: customLitutationCard(userID, lID, message, acceptOrDecline))
          ],
        ),
      ),
    );
  }
  Widget lituationThumbnailWidget(String lID){
    return StreamBuilder(
      stream: provider.getLituationStream(lID),
      builder: (context , l){
        if(!l.hasData){
          return Container();
        }
        if(l.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        print(l.data['thumbnail'][0].toString());
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     CachedNetworkImage(
     height: 125,
     imageUrl: l.data['thumbnail'][0].toString(),
     imageBuilder: (context, imageProvider) => Container(
       decoration: BoxDecoration(
         shape: BoxShape.rectangle,
         image: DecorationImage(
           image: imageProvider,
           fit: BoxFit.cover,
         ),
       ),
     ),
     placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).buttonColor),),
     errorWidget: (context, url, error) => nullUrl(), //TODO make custom nulllist for lituations
   ),
       Container(child: Text(l.data['title'] , style: infoLabel(Theme.of(context).buttonColor),), margin: EdgeInsets.only(top: 15 , left: 15),)
     ],
   );

      },
    );
  }

  Widget lituationNotificationsWidget(){
    print(widget.userID);
    return StreamBuilder(
        stream: provider.userLituationsStream(),
        builder: (context , lituations) {
          if (!lituations.hasData || lituations.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            List hostedLituations = List.from(lituations.data['lituations']);
            if (hostedLituations.length < 1) {
              return Container(margin:EdgeInsets.only(top: 25),child: Text('There are no pending RSVPs' ,style: infoLabel(Theme.of(context).textSelectionColor)),);
            }else{
              List<Widget> lituationNotificationCards = [];
              List<String> added = [];
              print(hostedLituations.length);
              for (String id in hostedLituations) {
                if(!added.contains(id)){
                  lituationNotificationCount++;
                  added.add(id);
                  lituationNotificationCards.add(lituationNotificationCardWidget(id , activity_no_rsvps , false)
                  );
                }
              }
              return Column(
                children: lituationNotificationCards,
              );
            }

            return Container();
          }
        }
    );
  }
  Widget lituationNotificationCardWidget(String id , String message , bool showTitle){
    return StreamBuilder(
      stream: provider.getLituationStream(id),
      builder: (ctx , l){
        if(!l.hasData){
          return Container();
        }else{
          if(List.from(l.data['pending']).length < 1){
            return Column(
              children: [
                horizontalDivider(Theme.of(context).dividerColor, 250),
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 25),
                child: Text(showTitle?message + l.data['title']:message , textAlign: TextAlign.center, style: infoLabel(Theme.of(context).primaryColor)),
              ),
                horizontalDivider(Theme.of(context).dividerColor, 250),
              ],
            );
          }
          return Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text(l.data['title']),
                    ),
                   pendingUsersRsvpCard(id),
                  ],
                )),
              ],
            ),
          );
        }
      },
    );
  }
  Widget pendingVibingRequestList(){
    return StreamBuilder(
      stream: provider.vibingStream(),
      builder: (ctx , vibes){
        if(!vibes.hasData || vibes.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        if(vibes.data['pendingVibing'].length > 0) {
          print(vibes.data['pendingVibing'].toString());
          List<String> ids = List.from(vibes.data['pendingVibing']);
          List<Widget> cards = [];
          for(var id in ids){
            cards.add(vibingNotificationListTile(id));
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 15, 15, 0),
                child: Text('(' +
                    vibes.data['pendingVibing'].length.toString() +
                    ') ' + activity_vibing_count_hint , style: infoValue(Theme.of(context).textSelectionColor),),),
              Column(
                children: cards
              )
            ],
          );
        }
        return Container(
            margin: EdgeInsets.only(top: 25),
            child: Center(child: Text('there are no pending requests' , style: infoLabel(Theme.of(context).textSelectionColor),)));
      },
    );
  }
  Widget customLitutationCard(String userID , String lID , String message , List<Widget> buttons) {
    return StreamBuilder(
      stream: provider.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
            onTap: (){
              if(userID != widget.userID){
                _viewProfile(userID , user.data['username']);
              }
            },
            child:
            Card(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Container(
                  padding: EdgeInsets.only(top: 5 , bottom: 5 , right: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: CachedNetworkImage(
                          height: 45,
                          width: 45,
                          imageUrl: user.data['profileURL'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: status(user.data['status']['status'])),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).splashColor),),
                          errorWidget: (context, url, error) => nullUrl(),
                        ),
                      ),   // approveButton(userID),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 25, 0, 0),
                                child: new Text(user.data['username'],
                                  style: infoValue(Theme.of(context).buttonColor),textAlign: TextAlign.center,textScaleFactor: 1,)
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: new Text(message,
                                  style: infoValue(Theme.of(context).textSelectionColor),textAlign: TextAlign.center,textScaleFactor: 0.8,)
                            ),
                          ],),

                      ),
                      Expanded(
                        child: Row(
                          children: buttons
                        ),
                      ),
                    ],
                  )
              ),
            )
        );
      },
    );
  }
  Widget pendingUsersRsvpCard(String lID){
    return StreamBuilder(
        stream: provider.getLituationStream(lID),
        builder: (ctx , l){
          if(!l.hasData || l.connectionState == ConnectionState.waiting){
            return Container();
          }else{
            List rsvps = List.from(l.data['pending']);
            List added = [];
            List<Widget> rsvpDetailCards = [];
            if(rsvps.length < 1){
              return Container();
            }
            for(String id in rsvps){
              if(!added.contains(id)){
                vibeNotificationCount++;
                added.add(id);
                rsvpDetailCards.add(lituationRsvpNotificationCard(id , lID));
              }
            }
            return Column(
              children: rsvpDetailCards,
            );
          }
        }
    );
  }

  Widget lituationRsvpNotificationCard(String userID , String lID) {
    return StreamBuilder(
      stream: provider.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
            onTap: (){
              if(userID != widget.userID){
                _viewProfile(userID , user.data['username']);
              }
            },
            child:
            Card(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Container(
                  padding: EdgeInsets.only(top: 15 , bottom: 15 , right: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: user.data['profileURL'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: status(user.data['status']['status'])),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).splashColor),),
                          errorWidget: (context, url, error) => nullUrl(),
                        ),
                      ),   // approveButton(userID),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: new Text(user.data['username'],
                                  style: infoValue(Theme.of(context).buttonColor),textAlign: TextAlign.center,textScaleFactor: 1,)
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: new Text('RSVP\'d to your event',
                                  style: infoValue(Theme.of(context).textSelectionColor),textAlign: TextAlign.center,textScaleFactor: 0.8,)
                            ),
                          ],),

                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child:  rsvpAcceptButton(userID , lID)),
                            Expanded(child: rsvpDeclineButton(userID , lID)),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            )
        );
      },
    );
  }
  //TODO Notify user
  Widget rsvpAcceptButton(String userID , String lID){
    return Container( //lo
        height: 35, // in button
        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text('allow',style: TextStyle(color: Colors.white) ,textScaleFactor: 0.8,maxLines: 1,),
            onPressed: (){
              provider.acceptRSVP(userID , lID);
              showSnackBar(context, sBar('RSVP accepted!'));
            }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
        )
    );
  }

  Widget rsvpDeclineButton(String userID , String lID){
    return GestureDetector(
      child: Icon(Icons.cancel_outlined, color: Colors.red,),
      onTap: (){
        //TODO send notification to user
        showConfirmationDialog(context , 'This persons RSVP will be removed' , 'are you sure?' , [confirmCancelRSVP(userID , lID) , cancelDialogButton()]);
      },
    );
  }
  //TODO Notify user
  Widget invitationAcceptButton(String userID , String lID){
    return Container( //lo
        height: 35, // in button
        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text('accept',style: TextStyle(color: Colors.white) ,textScaleFactor: 0.8,maxLines: 1,),
            onPressed: (){
              //TODO ACCEPT INVITATION
              //provider.acceptInvitation(userID , lID);
              showSnackBar(context, sBar('Time to get LIT!'));
            }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
        )
    );
  }
  //TODO notify user
  Widget invitationDeclineButton(String userID , String lID){
    return  GestureDetector(
            child: Icon(Icons.cancel_outlined, color: Colors.red,),
            onTap: (){
              showConfirmationDialog(context , 'Decline this invitation?' , 'you\'ll miss out, \n are you sure?' , [confirmCancelInvitation(userID , lID) , cancelDialogButton()]);
            },
    );
  }
  Widget confirmCancelRSVP(String userID , String lID){
    return FlatButton(
      child: Text('yes'),
      onPressed: (){
        provider.cancelRSVP(userID , lID);
        Navigator.pop(context);
      },
    );
  }
  Widget confirmCancelInvitation(String userID , String lID){
    return FlatButton(
      child: Text('yes'),
      onPressed: (){
        //TODO CANCEL INVITATION
        //provider.cancelInvitation(userID , lID);
        Navigator.pop(context);
      },
    );
  }
  
  Widget vibingNotificationListTile(String userID) {
    return StreamBuilder(
      stream: provider.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
            onTap: (){
              if(userID != widget.userID){
                _viewProfile(userID , user.data['username']);
              }
            },
            child: Card(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Container(
                  padding: EdgeInsets.only(top: 15 , bottom: 15 , right: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: user.data['profileURL'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: status(user.data['status']['status'])),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).splashColor),),
                          errorWidget: (context, url, error) => nullUrl(),
                        ),
                      ),   // approveButton(userID),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: new Text(user.data['username'],
                                  style: infoValue(Theme.of(context).primaryColor),textAlign: TextAlign.center,textScaleFactor: 1,)
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: new Text('wants to vibe with you',
                                  style: infoValue(Theme.of(context).textSelectionColor),textAlign: TextAlign.center,textScaleFactor: 0.8,)
                            ),
                          ],),

                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(flex: 3,child: acceptPendingVibeButton(userID),),
                            Expanded(flex: 1,child:  declinePendingVibeButton(userID),),
                          ],
                        ),
                      )
                    ],
                  )
              ),
            )
        );
      },
    );
  }

  Widget acceptPendingVibeButton(String userID){
    return Container( //lo
        height: 30,
        child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text('accept' ,textScaleFactor: 0.8,),
            onPressed: (){
              //TODO send notification to user
              provider.acceptPendingVibe(userID);
              showSnackBar(context, sBar('vibe request accepted'));
            }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
        )
    );
  }
  Widget declinePendingVibeButton(String userID){
    return GestureDetector(
      child: Icon(Icons.cancel_outlined, color: Colors.red,),
      onTap: (){
        //TODO send notification to user
        provider.cancelVibeRequest(userID);
        showSnackBar(context, sBar('the request has been declined'));
      },
    );

  }
  Widget pendingVibedRequestList(){
    return StreamBuilder(
      stream: provider.vibedStream(),
      builder: (context , vibes){
        if(!vibes.hasData || vibes.connectionState ==  ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        if(List.from(vibes.data['pendingVibes']).length > 0){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO replace with Richtext
              Container(
                padding: EdgeInsets.fromLTRB(10, 15, 15, 0),
                child: Text(activity_vibed_count_hint + '( ' + vibes.data['pendingVibes'].length.toString() + ' ) vibe requests pending' , style: infoLabel(Theme.of(context).textSelectionColor),),),
              Container(
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vibes.data['pendingVibes'].length,
                  itemBuilder: (context , idx){
                    return pendingCircularProfileWidget(vibes.data['pendingVibes'][idx]);
                  },
                ),
              )
            ],
          );
        }
        return Container(
            margin: EdgeInsets.only(top: 50 , bottom: 50),
            child: Center(child: Text('you have no pending vibe requests' , style: infoLabel(Theme.of(context).textSelectionColor))));
      },

    );
  }

  Widget pendingCircularProfileWidget(String userID){
    return StreamBuilder(
      stream: provider.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
          onTap: (){
            if(userID != widget.userID){
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
                  removePendingVibeRequestButton(userID),
                ],
              )
          ),
        );
      },
    );
  }
  
  Widget removePendingVibeRequestButton(String userID){
    return Container(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: (){
            cancelVibeRequest(userID);
            },
          child:  Icon(Ionicons.ios_close_circle_outline, size: 20, color: Colors.red,),
        )
    );
  }
  void cancelVibeRequest(String userID){
    showConfirmationDialog(context , 'Cancel request with user' , 'are you sure?' , [confirmRemoveVibeButton(userID) , cancelDialogButton()]);
  }
  Widget confirmRemoveVibeButton(String userID){
    return FlatButton(
      child: Text('remove'),
      onPressed: (){
        provider.cancelVibeRequest(userID);
        Navigator.pop(context);
      },
    );
  }
  Color status(String data){
    if(data.contains('online')){
      return Colors.lightGreenAccent;
    }
    return Colors.red;
  }

  void _viewProfile(String id , String username){
    UserVisit v = UserVisit();
    v.visitorID = widget.userID;
    v.visitedID = id;
    v.visitNote = username;
    print(v.visitNote);
    Navigator.pushNamed(context, VisitProfilePageRoute , arguments: v);
  }
}
