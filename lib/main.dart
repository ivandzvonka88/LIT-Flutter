import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lit_beta/Strings/constants.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Styles/app_themes.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:lit_beta/Styles/theme_resolver.dart';
import 'package:lit_beta/Utils/SharedPrefsHelper.dart';
import 'package:provider/provider.dart';

import 'Nav/router.dart' as router;
import 'Nav/routes.dart';
import 'Styles/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var theme;
  if(HelperExtension.sharedPreferenceUserTheme == 'auto'){
    if(hourCheck() == 0){
      theme = t1;
    }else{
      theme = t2;
    }
  }else{
    if(HelperExtension.sharedPreferenceUserTheme == 'light'){
      theme = t1;
    }else{
      theme = t2;
    }
  }
  runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(theme), child: MyApp(),
      )
      );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Sets the app theme on launch
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    //Forces app to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
   return new  MaterialApp(
      initialRoute: MainPageRoute,
      onGenerateRoute: router.generateRoute,
      theme: themeNotifier.getTheme(),
    );

  }
}

Future<ThemeData> getTheme() async {
  await HelperExtension.getUserThemeSharedPrefs().then((value){
  switch(value){
    case "light":
      return t1;
    case "dark":
      return t2;
    case "auto":
      return hourCheck();
  }
  });
}
int hourCheck() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 0;
  }
  if (hour < 17) {
    return 0;
  }
  return 1;
}
class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainPage> {

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return splashProvider();
  }

  Widget splashProvider(){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(25)),
          logo(),
          Padding(padding: EdgeInsets.all(25)),
          loginButton(),
          registerButton(),
        ],
      ),
    );
  }

  //dart
  Widget logo(){
    return Column(
      children: [
      Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Image.asset('assets/images/litlogo.png'), width: 200,),
        Container(child: Text('welcome\nto' , style: TextStyle(color: Theme.of(context).textSelectionColor),textAlign: TextAlign.center,),),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text('Location I turn up' , style: TextStyle(color: Theme.of(context).textSelectionColor,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Itim-Regular'
            ),
          ),
        ),
      ],
    );
  }
  Widget registerButton(){
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(50, 25, 50, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: RaisedButton(
            color: Theme.of(context).buttonColor,
            textColor: Theme.of(context).textSelectionColor,
            child: Text(register_label ,style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
              _toRegister();
            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }

  Widget loginButton(){
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(50, 25, 50, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: RaisedButton(
            color: Theme.of(context).buttonColor,
            textColor: Theme.of(context).textSelectionColor,
            child: Text(login_label ,style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
              _toLogin();
            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }

  void _toLogin(){
    Navigator.pushNamed(context, LoginPageRoute);
  }
  void _toRegister(){
    Navigator.pushNamed(context, RegisterPageRoute);
  }
}
