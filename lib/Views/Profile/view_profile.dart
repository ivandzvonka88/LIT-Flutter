
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
import 'package:lit_beta/Providers/ProfileProvider/view_profile_provider.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:path/path.dart' as Path;


import 'package:lit_beta/Styles/theme_resolver.dart';

class VisitProfilePage extends StatefulWidget {
  VisitProfilePage({Key key , this.visit}) : super(key: key);
  final UserVisit visit;


  @override
  _VisitProfileState createState() => _VisitProfileState();
}

class _VisitProfileState extends State<VisitProfilePage>{

  ViewProfileProvider provider;
  int _tabIdx = 0;

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    provider = ViewProfileProvider(widget.visit.visitedID);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return profileWidget(context);

  }

  //Silverbar usage
  Widget profileWidget(BuildContext c) {
    if (widget.visit.visitedID == null) {
      return Container();
    }
    return StreamBuilder(
        stream: provider.userSettingsStream(),
        builder: (context , settings){
          if(!settings.hasData){
            return CircularProgressIndicator();
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
                appBar: topNav(backButton(), userThumbnailAppbar(profileUrl), [Container()], Theme.of(context).scaffoldBackgroundColor),
                backgroundColor: Theme.of(context).backgroundColor,
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(5)),
                      userThumbnail(profileUrl , username),
                      vibeAndChatRow(),
                      statsRow(getUserStats(clout)),
                      //profileIndexedStackProvider(c, u)
                    ],
                  ),
                ),
              );
            },
          );
        }

    );
  }

  Widget vibeAndChatRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        vibeButton(),
        chatButton(),
      ],
    );
  }
  Widget vibeButton(){
    return StreamBuilder(
      stream: provider.vibingStream(),
      builder: (context , vibing){
        if(!vibing.hasData){
          return Container();
        }
        String val = 'vibe';
        Color btnColor = Theme.of(context).primaryColor;
        int status = 0; //0 vibe , 1 vibed , 2 pending
        if(List.from(vibing.data['vibing']).contains(widget.visit.visitorID)){
          val = 'vibed';
          btnColor = Colors.green;
          status = 1;
        }
        if(List.from(vibing.data['pendingVibing']).contains(widget.visit.visitorID)){
          val = 'cancel';
          btnColor = Colors.red;
          status = 2;
        }

        return Container( //lo
            height: 35,// in button
            margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
            child: RaisedButton(
                color: btnColor,
                textColor: Theme.of(context).textSelectionColor,
                child: Text(val , style: infoValue(Theme.of(context).textSelectionColor),),
                onPressed: (){
                 setState(() {
                   provider.sendVibeRequest(widget.visit.visitorID);
                 });
                }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
            )
        );

      },
    );
  }

  Widget chatButton(){
    return StreamBuilder(
      stream: provider.getVisitorVibingStream(widget.visit.visitorID),
      builder: (context , vibing){
        if(!vibing.hasData){
          return Container();
        }
        String val = 'chat';
        Color btnColor = Theme.of(context).primaryColor;
        int status = 0; //0 vibe , 1 vibed , 2 pending
        if(List.from(vibing.data['vibing']).contains(widget.visit.visitedID)){
          return Container( //lo
              height: 35,// in button
              margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
              child: RaisedButton(
                  color: btnColor,
                  child: Text(val , style: infoValue(Theme.of(context).textSelectionColor),),
                  onPressed: (){
                    setState(() {
                      //TODO open chat with user
                      //chatWithUser(status);
                    });
                  }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
              )
          );
        }
      return Container();


      },
    );
  }

  void showVibeSnackBar(BuildContext context, String username, String userID , int msgID){
    String msg = '';
    switch(msgID){
      case 0:{
        msg = 'you\'ve asked to vibe with $username!';
        break;
      }
      case 1:{
        msg = 'pending vibe with $username cancelled.';
        break;
      }
      case 2:{
        msg = 'chat pending until you vibe with $username';
        break;
      }
    }
  showSnackBar(context, sBar(msg));

  }
  SnackBar sBar(String text){
    return SnackBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Text(text , style: TextStyle(color: Theme.of(context).textSelectionColor),));
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
  List<Widget> getUserStats(String clout){
    List<Widget> s = [];
    s.add(vibingTabProvider());
    s.add(divider(Theme.of(context).textSelectionColor));
    s.add(cloutTabProvider(clout));
    s.add(divider(Theme.of(context).textSelectionColor));
    s.add(vibedTabProvider());
    return s;
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
              _viewVibes('vibing');
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
              _viewVibes('vibed');
            },
          );
        }

    );
  }
  void _viewVibes(String note){
    UserVisit v = UserVisit(visitedID: widget.visit.visitedID ,visitorID:widget.visit.visitorID, visitNote: note);
    Navigator.of(context).pushNamed(VibesPageRoute , arguments: v);
  }
  Widget usernameWidget(String val){
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Text(val ,  style: infoLabel(Theme.of(context).textSelectionColor), textScaleFactor: 1.2,),
    );
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

  Widget backButton(){
    return GestureDetector(
      onTap: (){Navigator.of(context).pop();},
      child: Icon(Icons.arrow_back , color: Theme.of(context).buttonColor,),
    );
  }
}
