import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_context/dialog_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lit_beta/Styles/text_styles.dart';

String parseVibes(String vibes){
  if(vibes == null){
    return '0';
  }
  return vibes;
}


showSnackBar(BuildContext context , SnackBar bar){
  Scaffold.of(context).showSnackBar(bar);
}

String parseDate(Timestamp d){
  int c = 1000;
  DateTime date = DateTime.fromMicrosecondsSinceEpoch(d.millisecondsSinceEpoch * c);
  return DateFormat.yMd().addPattern('\n').add_jm().format(date);
}

showConfirmationDialog(BuildContext context ,String title , String message , List<Widget> actions ){
  showDialog(
      context: context,
      builder: (_) => new CupertinoAlertDialog(
        title: new Text(title , style: infoLabel(Theme.of(context).buttonColor),),
        content: new Text(message , style: infoValue(Theme.of(context).textSelectionColor),),
        actions: actions
      ));
}