import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lit_beta/Strings/constants.dart';
import 'package:lit_beta/Styles/text_styles.dart';

import 'common_functions.dart';

Widget selectedIndicator(Color c) {
  return Container(
    height: 0.7,
    width: 75,
    color: c,
  );
}
Widget divider(Color c) {
  return Container(
    height: 25,
    width: 0.7,
    color: c,
  );
}
Widget horizontalDivider(Color c , double w) {
  return Opacity(opacity: 0.3,
  child: Container(
      margin: EdgeInsets.only(left: 10 , right: 10),
  height: 0.7,
  width: w,
  color: c,
  ),
  );
}
  Widget topNav(Widget leading , Widget title , List<Widget> actions, Color c){
    return AppBar(
      backgroundColor: c,
      centerTitle: true,
      leading: leading,
      title: title,
      actions: actions,
    );
  }

Widget nullUrl(){
  return Container(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.4,
          child: Image.asset('assets/images/litlogo.png'),
        )
      ],
    ),
  );
}

//labeL
Widget bioCard(List<Widget> labelAndEdit , Widget value, Color bgColor){
  return Card(
    color: bgColor,
    elevation: 3,
    child: Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 10 , right: 10),
      child: Column(
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labelAndEdit
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Container(
                    padding: EdgeInsets.fromLTRB(0 , 15 , 0 , 0),
                    child: value
                ))
              ]
          )
        ],
      ),
    ),
  );
}

Widget userThumbnailAppbar(String url){
  return CachedNetworkImage(
    height: 50,
    width: 50,
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
    errorWidget: (context, url, error) => nullUrl(),
  );
}
Widget settingCardSwitch(String label , String value, Widget switchWidget, Color bgColor , Color labelCol , Color textCol){
  return Card(
    color: bgColor,
    elevation: 3,
    child: Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            child:
            Text(label ,style: infoLabel(labelCol),),
            padding: EdgeInsets.fromLTRB(0 , 5 , 0 , 0),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0 , 10 , 0 , 0),
                        child: Text(value , style: infoValue(textCol),)
                    )
                ),
                switchWidget
              ]
          )
        ],
      ),
    ),
  );
}
Widget infoCard(String label , String value , IconData icon , Color bgColor , Color labelCol , Color textCol){
  return Card(
    color: bgColor,
    elevation: 3,
    child: Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            child:
            Text(label ,style: infoLabel(labelCol),),
            padding: EdgeInsets.fromLTRB(0 , 5 , 0 , 0),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Container(
                    padding: EdgeInsets.fromLTRB(0 , 10 , 0 , 0),
                    child: Text(value , style: infoValue(textCol),)
                )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0 , 0 , 0 , 0),
                  margin: EdgeInsets.fromLTRB(0 ,0 , 15 , 15),
                  child:Icon(icon, color: labelCol),
                )
              ]
          )
        ],
      ),
    ),
  );
}
//
Widget editableBioCard(List<Widget> labelAndEdit , Widget value, Color bgColor){
  return Card(
    color: bgColor,
    elevation: 3,
    child: Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labelAndEdit
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Container(
                  child: value
                ))
              ]
          )
        ],
      ),
    ),
  );
}

Widget editableInfoCard(Widget label , Widget value, Color bgColor){
  return Card(
    color: bgColor,
    elevation: 3,
    child: Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [label]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Container(
                    child: value
                ))
              ]
          )
        ],
      ),
    ),
  );
}

Widget editableLituationInfoCard(Widget label ,Widget hint, Widget value, Color bgColor){
  return Card(
    color: bgColor,
    elevation: 3,
    child: Container(
      margin: EdgeInsets.fromLTRB(0, 10, 10, 15),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
              label,
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Container(
                    child: value
                ))
              ]
          ),
          hint,
        ],
      ),
    ),
  );
}

Widget infoSectionHeader(String title , Color c){
  return Container(
    margin: EdgeInsets.only(top: 25 , left: 5),
    height: 35,
    width: double.infinity,
    child:
    Text(title ,style: infoLabel(c),textAlign: TextAlign.left, textScaleFactor: 1.2,),
  );
}

Widget pageTitle(String title , Color c){
  return Container(
    child: Text(title , textAlign: TextAlign.center, style: TextStyle(color: c),textScaleFactor: 1.2,),
  );
}

Widget lituationCardLabel(String title , Color c){
  return Container(
    child: Text(title , textAlign: TextAlign.center, style: infoLabel(c),),
  );
}

Widget lituationCardHint(String hint , Color c){
  return Container(
    child: Text(hint , textAlign: TextAlign.center, style: TextStyle(color: c),textScaleFactor: 0.8,),
  );
}

Widget viewList(BuildContext context, List data, List<Widget> removeButtons , String listname , Color labelCol){
  if(data.length != null || data.length > 0) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 35,
                width: double.infinity,
                child: Text(listname,
                  style: infoValue(labelCol),
                  textAlign: TextAlign.left,),
                padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
              ),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                )
            ),
          ],
        )
        ,
        Expanded(
          //padding: EdgeInsets.all(0),
          // height: 185,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (ctx, idx) {
                return Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    width: 150,
                    child: Stack(
                      children: [
                        lituationDetailCard(context , data[idx]['eventID'],
                            data[idx]['thumbnail'][0], data[idx]['title'],
                            parseDate(data[idx]['date']),
                            data[idx]['entry']),
                        Positioned(child: removeButtons[idx],
                          top: 10,
                          right: 10,
                        )
                      ],
                    )
                );
              }
          ),
        )
      ],
    );
  }
}
Widget placeResultTile(BuildContext context, PlacesSearchResult suggestion){
  return  ListTile(
    contentPadding: EdgeInsets.all(5),
    leading: Image.asset('assets/images/litlocationicon.png'),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(suggestion.name , style: TextStyle(color: Theme.of(context).primaryColor , decoration: TextDecoration.none , fontSize: 14)),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        Text(suggestion.formattedAddress , style: TextStyle(color: Theme.of(context).textSelectionColor , decoration: TextDecoration.none , fontSize: 12.5)),

      ],
    ),
  );
}
Widget lituationCategoryResultTile(String suggestion , BuildContext context){
  return ListTile(
    contentPadding: EdgeInsets.all(15),
    leading: Image.asset(logo),
    title: Text(suggestion , style: TextStyle(color: Theme.of(context).textSelectionColor , decoration: TextDecoration.none),),
  );
}
Widget userResultTile(String username , String profile , BuildContext context){
  return ListTile(
    contentPadding: EdgeInsets.all(15),
    leading: userProfileThumbnail(profile, 'online'),
    title: Text(username , style: TextStyle(color: Theme.of(context).textSelectionColor , decoration: TextDecoration.none),),
  );
}
Widget lituationDetailCard(BuildContext ctx , String lID , String thumbnail , String title , String date , String entry){
  return Card(
    elevation: 3,
      child:  Stack(
        children: [
         Opacity(
                opacity: 1,
                child:  CachedNetworkImage(
                  imageUrl: thumbnail,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).buttonColor),),
                  errorWidget: (context, url, error) => nullUrl(),
                ),
              ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 5,
        child: Container(
          color: Colors.black26,
          height: 75,
          child: Column(
            children: [
              Expanded(
                child: Text(title , style: TextStyle(color: Colors.white , fontSize: 14 ,fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
              ),
              Expanded(
                child: Text(entry , style: TextStyle(color: Colors.white , fontSize: 12 ,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              ),
              Expanded(
                child: Text(date , style: TextStyle(color: Colors.white , fontSize: 12 ,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              ),
            ],
          ),
        )
      )
        ],
      ),
  );
}

Widget nullList(String username , String listname , Color c){
  return Column(
      children: [
        Container(
          height: 35,
          width: double.infinity,
          child: Text(listname,
            style: infoValue(c),
            textAlign: TextAlign.left,),
          padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
        ),
        Container(
          height: 150,
          alignment: Alignment.center,
          child: Center(child: Text( username + ' has no ' + listname , style: TextStyle(color: c),),),
        )
      ]);
}
Color status(String data){
  if(data.contains('online')){
    return Colors.lightGreenAccent;
  }
  return Colors.red;
}
Widget userProfileThumbnail(String url ,  String stat) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: CachedNetworkImage(
      height: 45,
      width: 45,
      imageUrl: url,
      imageBuilder: (context, imageProvider) =>
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: status(stat)),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
      placeholder: (context, url) =>
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Theme
                .of(context)
                .splashColor),),
      errorWidget: (context, url, error) => nullUrl(),
    ),
  );
}
