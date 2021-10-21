
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lit_beta/Extensions/common_functions.dart';
import 'package:lit_beta/Extensions/common_widgets.dart';
import 'package:lit_beta/Models/User.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Providers/ProfileProvider/vibe_provider.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:lit_beta/Views/Profile/view_profile.dart';

class VibesPage extends StatefulWidget{
  VibesPage({Key key , this.visit}) : super(key: key);
  final UserVisit visit;

  @override
  _VibesState createState() => new _VibesState();
  
}

class _VibesState extends State<VibesPage>{

  VibeProvider vp;
  int _tabIndex = 0;
  List<String> vibed = [];
  List<String> vibing = [];

  @override
  void initState() {
    if(widget.visit.visitNote.isNotEmpty && widget.visit.visitNote.contains('vibed')){
      _tabIndex = 0;
    }else{
      _tabIndex = 1;
    }

   vp = VibeProvider(widget.visit.visitedID);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topNav(backButton(),usernameThumbnail(widget.visit.visitedID), [Container()], Theme.of(context).scaffoldBackgroundColor),
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body: Column(
          children: [
            Expanded(flex: 1,child: indexTabBar(),),
            Expanded(flex: 8,child: vibesIndexedStackProvider(),)
          ],
        )
    );
  }


  Widget indexTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child:  tappableTab(vibesIndexedStackTab('Vibing', 1), 1),),
          Expanded(child: tappableTab(vibesIndexedStackTab('Vibed', 0), 0),),
        ],
      ),
    );
  }

  Widget vibesIndexedStackProvider(){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(child: IndexedStack(
              index: _tabIndex,
              children: [
                //TODO use provder
                vibedList(),
                vibingList(),
              ],
            ))
          ],
        ),
      ),
    );
  }
  Widget vibingList(){
    return StreamBuilder(
      stream: vp.vibingStream(),
      builder: (ctx , v){
        if(!v.hasData || v.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        if(v.data['vibing'].length < 1 && v.data['pendingVibing'].length < 1){
          return emptyListPrompt('hasn\'t vibed with anyone yet.');
        }

        Widget pending = Container();

        if(v.data['pendingVibing'].length > 0){
          pending = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child:  Text('you have ( ' + v.data['pendingVibing'].length.toString() + ' ) pending vibes' ,style: infoValue(Theme.of(context).textSelectionColor),),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: v.data['pendingVibing'].length,
                  itemBuilder: (ctx, idx) {
                    return pendingCircularProfileWidget(
                        v.data['pendingVibing'][idx]);
                  },
                ),
              ),
            ],
          );
        }
        Widget vibes = ListView.builder(
          itemCount: v.data['vibing'].length,
          itemBuilder: (ctx , idx){
            return vibingResult(v.data['vibing'][idx]);
          },
        );

        return Column(
          children: [
            pending,
            Expanded(flex: 1,child: vibes)
          ],
        );
      },
    );
  }
  Widget vibedList(){
    return StreamBuilder(
      stream: vp.vibedStream(),
      builder: (ctx , v){
        if(!v.hasData || v.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        if(v.data['vibed'].length < 1){
          return emptyListPrompt('hasn\'t vibed with anyone yet.');
        }

        return ListView.builder(
          itemCount: v.data['vibed'].length,
          itemBuilder: (ctx , idx){
            return vibedResult(v.data['vibed'][idx]);
          },
        );
      },
    );
  }
  Widget approveButton(BuildContext context , String userID){
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: (){
            vp.acceptVibe(userID);
            //showSnackBar(context, sBar('vibe accepted'));
            },
          child:Icon(Ionicons.ios_checkmark_circle_outline, size: 20, color: Colors.green,),
        )
    );
  }

  Widget declinePendingVibeButton(String userID , String username){
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: (){
            cancelVibeRequest(userID , username);
            //showSnackBar(context, sBar('vibe declined'));
          },
          child:Icon(Icons.cancel_outlined, size: 20, color: Colors.red,),
        )
    );
  }
  void cancelVibeRequest(String userID , String username){
    showConfirmationDialog(context , 'Cancel request with $username' , 'are you sure?' , [confirmRemoveVibeButton(userID) , cancelDialogButton()]);
  }
  Widget confirmRemoveVibeButton(String userID){
    return FlatButton(
      child: Text('remove'),
      onPressed: (){
        vp.cancelVibeRequest(userID);
        Navigator.pop(context);
      },
    );
  }
  Widget pendingCircularProfileWidget(String userID){
    return StreamBuilder(
      stream: vp.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
          onTap: (){if(userID != widget.visit.visitorID){
            _viewProfile(widget.visit.visitorID, userID);
          }
          },
          child: Container(
              child: Row(
                children: [
                  declinePendingVibeButton(userID , user.data['username']),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CachedNetworkImage(
                          height: 45,
                          width: 45,
                          imageUrl: user.data['profileURL'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
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
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: new Text(user.data['username'],
                            style: Theme.of(context).textTheme.headline3,textAlign: TextAlign.center,textScaleFactor: 0.9,)
                      ),
                    ],
                  ),
                  approveButton(context ,userID),
                ],
              )
          ),
        );
      },
    );
  }

  SnackBar sBar(String text){
    return SnackBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Text(text , style: TextStyle(color: Theme.of(context).textSelectionColor),));
  }
  Widget confirmCancelVibed(String userID){
    return FlatButton(
      child: Text('yes'),
      onPressed: (){
        vp.cancelVibed(userID);
        Navigator.pop(context);
      },
    );
  }
  Widget confirmCancelVibing(String userID){
    return FlatButton(
      child: Text('yes'),
      onPressed: (){
        vp.cancelVibing(userID);
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
  Widget removeVibedButton(String userID){
     return GestureDetector(
      child: Icon(Icons.cancel_outlined, color: Colors.red,),
      onTap: (){
        //TODO send notification to user
        showConfirmationDialog(context , 'remove from vibed?' , 'are you sure?' , [confirmCancelVibing(userID) , cancelDialogButton()]);
        //vp.removevibing
        showSnackBar(context, sBar('removed from vibed'));
      },
    );

  }
  Widget removeVibingButton(String userID){
    return GestureDetector(
      child: Icon(Icons.cancel_outlined, color: Colors.red,),
      onTap: (){
        //TODO send notification to user
        showConfirmationDialog(context , 'remove from vibing?' , 'are you sure?' , [confirmCancelVibed(userID) , cancelDialogButton()]);
        //vp.removevibing
        showSnackBar(context, sBar('removed from vibing'));
      },
    );

  }
  Widget emptyListPrompt(String prompt){
    return  Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            usernameWidget(widget.visit.visitedID),
            Text(' $prompt' ,textScaleFactor: 1.2, style: infoValue(Theme.of(context).primaryColor),)
          ],
        ),
      ),
    );
  }

  Widget userThumbnail(AsyncSnapshot u){
    if(!u.data){
      return pageTitle(widget.visit.visitNote, Theme.of(context).textSelectionColor);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          height: 50,
          width: 50,
          imageUrl: u.data['profileURL'],
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
          child: usernameWidget(u.data['username']),
        )
      ],
    );
  }

  Widget usernameWidget(String userID){
    return StreamBuilder(
        stream: vp.getUserStreamByID(userID),
        builder: (context , user){
          if(!user.hasData || user.connectionState == ConnectionState.waiting){
            return Text('...');
          }
          return Text(user.data['username'] ,textScaleFactor: 1.2, style: TextStyle(color: Theme.of(context).dividerColor),);

        }
    );
  }
  Widget usernameThumbnail(String userID){
    return StreamBuilder(
        stream: vp.getUserStreamByID(userID),
        builder: (context , user){
          if(!user.hasData || user.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          return CachedNetworkImage(
            height: 50,
            width: 50,
            imageUrl: user.data['profileURL'],
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
            errorWidget: (context, url, error) => nullUrl(),
          );
        }
    );
  }
  Widget tappableTab(Widget tab, int idx) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabIndex = idx;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 5),
        child: tab,
      ),
    );
  }

  Widget vibesIndexedStackTab(String title, int idx) {
    Color c = Theme.of(context).buttonColor;
    Widget indicator;
    var scale = 0.9;
    if (idx == _tabIndex) {
      indicator = selectedIndicator(c);
      c = Theme.of(context).dividerColor;
      scale = 1.1;
    }
    else {
      indicator = Container();
      c = Theme.of(context).buttonColor;
      scale = 0.9;
    }
    return Column(
      children: [
      Expanded( flex: 9, child: Container(
        child: Text(title, style: TextStyle(color: c, fontSize: 14),
          textAlign: TextAlign.center,
          textScaleFactor: scale,),
      ),),
        Expanded(child: indicator, flex: 1)
      ],
    );
  }
  Widget backButton(){
    return GestureDetector(
      onTap: (){Navigator.of(context).pop();},
      child: Icon(Icons.arrow_back , color: Theme.of(context).buttonColor,),
    );
  }

  Widget vibingResult(String userID) {
    return StreamBuilder(
      stream: vp.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
            onTap: (){
              if(userID != widget.visit.visitorID){
                //TODO ontap show profile
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
                                  style: infoValue(Theme.of(context).buttonColor),textAlign: TextAlign.center,textScaleFactor: 1,)
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: new Text('vibing',
                                  style: infoValue(Theme.of(context).textSelectionColor),textAlign: TextAlign.center,textScaleFactor: 0.8,)
                            ),
                          ],),

                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(flex: 3,child: vibingOptionsButton(userID , user.data['username']),),
                            //Expanded(flex: 1,child:  interactionOptions(userID),),
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

  void _viewProfile(String id , String username){
    UserVisit v = UserVisit();
    v.visitorID = widget.visit.visitorID;
    v.visitedID = id;
    v.visitNote = username;
    print(v.visitNote);
    Navigator.pushNamed(context, VisitProfilePageRoute , arguments: v);
  }

  Widget vibedResult(String userID) {
    return StreamBuilder(
      stream: vp.getUserStreamByID(userID),
      builder: (ctx , user){
        if(!user.hasData){
          return CircularProgressIndicator();
        }
        return GestureDetector(
            onTap: (){
              if(userID != widget.visit.visitorID){
                //TODO ontap show profile
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
                                child: new Text('vibed',
                                  style: infoValue(Theme.of(context).textSelectionColor),textAlign: TextAlign.center,textScaleFactor: 0.8,)
                            ),
                          ],),

                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(flex: 3,child: vibedOptionsButton(userID , user.data['username']),),
                            Expanded(flex: 1,child:  interactionOptions(userID),),
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

  Widget interactionOptions(String userID){
    return GestureDetector(
      child: Icon(Icons.more_vert_rounded),
      onTap: (){
        //TODO Show invite, share, unvibe
      },
    );
  }

  Widget vibingOptionsButton(String userID, String username){
    //if we havent vibed back show vibe
    //if they are pending show accept or decline row
    //else show ~vibed~
    if(widget.visit.visitorID != widget.visit.visitedID){
      return Container( //lo
          height: 35,
          child: RaisedButton(
              color: Theme.of(context).buttonColor,
              textColor: Colors.white,
              child: Text('visit' ,textScaleFactor: 0.7,),
              onPressed: (){
                _viewProfile(userID , username);
              }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
          )
      );
    }
    return StreamBuilder(
      stream: vp.vibedStream(),
      builder: (context, v){
        if(!v.hasData){
          return CircularProgressIndicator();
        }
        if(v.data['vibed'].contains(userID)){
          return Container( //lo
              height: 35,
              child: RaisedButton(
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                  child: Text('visit' ,textScaleFactor: 0.7,),
                  onPressed: (){
                    _viewProfile(userID , username);
                  }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
              )
          );
        }
        if(v.data['pendingVibes'].contains(userID)){
          return Container( //lo
              height: 35,
              child: RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('cancel' ,textScaleFactor: 0.7,),
                  onPressed: (){
                    vp.sendVibeRequest(widget.visit.visitorID , userID);
                  }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
              )
          );
        }
        return Container( //lo
            height: 35,
            child: RaisedButton(
                color: Theme.of(context).buttonColor,
                textColor: Colors.white,
                child: Text('vibe' ,textScaleFactor: 0.7,),
                onPressed: (){
                  vp.sendVibeRequest(widget.visit.visitorID , userID);
                }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
            )
        );
      },
    );
  }
  Widget vibedOptionsButton(String userID, String username){
    //if we havent vibed back show vibe
    //if they are pending show accept or decline row
    //else show ~vibed~
    if(widget.visit.visitorID != widget.visit.visitedID){
      return Container( //lo
          height: 35,
          child: RaisedButton(
              color: Theme.of(context).buttonColor,
              textColor: Colors.white,
              child: Text('visit' ,textScaleFactor: 0.7,),
              onPressed: (){
                _viewProfile(userID , username);
              }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
          )
      );
    }
    return StreamBuilder(
      stream: vp.vibedStream(),
      builder: (context, v){
        if(!v.hasData){
          return CircularProgressIndicator();
        }

        return Container( //lo
            height: 35,
            child: RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('remove' ,textScaleFactor: 0.7,),
                onPressed: (){
                  vp.cancelVibed(userID);
                }, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
            )
        );
      },
    );
  }
}
