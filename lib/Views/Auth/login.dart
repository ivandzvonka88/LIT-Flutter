
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lit_beta/DBC/Auth.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Providers/AuthProvider/login_provider.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:lit_beta/Styles/theme_resolver.dart';
import 'package:lit_beta/Utils/SharedPrefsHelper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  ThemeResolver t;
  String error = '';
  TextEditingController email_tec;
  TextEditingController password_tec;
  bool obscure = false;
  GlobalKey<FormState> _formKey;
  LoginProvider lp = LoginProvider();
  Auth db = Auth();
  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    _formKey = new GlobalKey<FormState>();
    email_tec = TextEditingController();
    password_tec = TextEditingController();
    t = ThemeResolver(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: loginProvider(),
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );
  }

  Widget loginProvider(){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            logoWidget(),
            emailTextField(),
            passwordTextField(),
            errorText(),
            loginButton(),
            noAccountText(),
            forgotPasswordText(),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
  Widget noAccountText(){
    return Container(
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: GestureDetector(
            onTap: () => { _toRegister() },
            child: Text(no_account_prompt ,
              style: TextStyle(color: Theme.of(context).indicatorColor ,  fontSize: 16),
            )
        ));
  }
  Widget errorText(){
    return  Container( //forgot your password? text
        height: 25,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Text(error , style: TextStyle(color: Theme.of(context).errorColor, fontSize: 14 ), textAlign: TextAlign.center,)
    );
  }
  Widget forgotPasswordText(){
    return Container( //forgot your password? text
      height: 35,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: GestureDetector(
          onTap: () => {},
          child: Text(forgot_password_prompt ,
              style: TextStyle(color: Theme.of(context).textSelectionColor), textScaleFactor: 0.8,)
      ),
    );
  }
  Widget logoWidget(){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Image.asset('assets/images/litlogo.png'), height: 175,
    );
  }
  Widget emailTextField(){
    return Container(
      margin: EdgeInsets.fromLTRB(15, 35, 15, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        validator: (input){
          if(input.trim().isEmpty){
            return 'please enter your email';
          }
          if(!input.contains('@') || !input.contains('.') || input.contains(' ')){
            return 'enter a valid email';
          }else
          return null;
        },
        onSaved: (input){
          email_tec.text = input;
        },
        onChanged: (input){
          _formKey.currentState.save();
        },
        maxLines: 1,
        minLines: 1,
        maxLength: 150,
        cursorColor: Theme.of(context).primaryColor,
        style: infoValue(Theme.of(context).textSelectionColor),
        decoration: InputDecoration(
            labelText: email_label,
            suffixIcon: new Icon(Icons.email ,
              color: Theme.of(context).primaryColor,
            ),
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1),),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2))
        ),
      ),
    );
  }

  Widget passwordTextField(){
    return Container(
      margin: EdgeInsets.fromLTRB(15, 35, 15, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        //password input
        validator: (input){
          if(input.isEmpty){
            return 'enter your password';
          }
          if(input.contains(" ")){
            input.replaceAll(" ", "");
          }return null;

        },
        onSaved: (input){
          password_tec.text = input;
          _formKey.currentState.validate();
        },
        maxLines: 1,
        minLines: 1,
        maxLength: 16,
        cursorColor: Theme.of(context).primaryColor,
        style: infoValue(Theme.of(context).textSelectionColor),
        obscureText: obscure,
        decoration: InputDecoration(
            labelText: password_label,
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: (){_toggle();},
            ),
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1),),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2))
        ),
      ),
    );
  }
  Widget loginButton(){
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(45, 25, 45, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: RaisedButton(
            child: Text(login_label ,style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
             loginInUser();
            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }
  void _toggle(){
    setState(() {
      obscure = !obscure;
    });
  }
  void _toRegister(){
    Navigator.pushReplacementNamed(context, RegisterPageRoute);
  }
  void _toLanding(){
    Navigator.pushReplacementNamed(context, HomePageRoute);
  }
  void loginInUser() async {
    final loginForm = _formKey.currentState;
    loginForm.save();
    if(loginForm.validate()) {
      await db.signIn(email_tec.text, password_tec.text).then((value) {
        if(value.contains('ERROR')){
          setState(() {
            error = value.split(':')[1];
          });
          return;
        }
        HelperExtension.saveSharedPreferenceUserID(value);
        lp.currentUser().then((u){
          HelperExtension.saveUserEmailSharedPrefs(u.email);
          HelperExtension.saveUserNameSharedPrefs(u.displayName);
        });
        _toHome(value);
        return;
      });
    }
  }
  void _toHome(String uID){
    Navigator.pushReplacementNamed(context, HomePageRoute , arguments: uID);
  }
}
