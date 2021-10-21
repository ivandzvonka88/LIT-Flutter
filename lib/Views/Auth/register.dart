
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lit_beta/Nav/routes.dart';
import 'package:lit_beta/Providers/AuthProvider/register_provider.dart';
import 'package:lit_beta/Strings/hint_texts.dart';
import 'package:lit_beta/Styles/text_styles.dart';
import 'package:lit_beta/Styles/theme_resolver.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  ThemeResolver t;
  String error = '';
  TextEditingController email_tec;
  TextEditingController username_tec;
  TextEditingController password_tec;
  TextEditingController confirm_password_tec;
  String _email = '';
  String _username = '';
  String _password = '';
  String _confirm_password = '';
  bool pObscure = false;
  bool cpObscure = false;
  RegisterProvider rp = RegisterProvider();
  GlobalKey<FormState> _formKey;

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    _formKey = new GlobalKey<FormState>();
    email_tec = TextEditingController();
    password_tec = TextEditingController();
    username_tec = TextEditingController();
    confirm_password_tec = TextEditingController();
    t = ThemeResolver(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: registerProvider(),
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );
  }

  Widget registerProvider(){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            logoWidget(),
            emailInput(),
            usernameInput(),
            passwordInput(),
            confirmPasswordInput(),
            errorText(),
            registerButton(),
            haveAnAccountText(),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
  Widget errorText(){
    return  Container( //forgot your password? text
        height: 25,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Text(error , style: TextStyle(color: Colors.red, fontSize: 14 ), textAlign: TextAlign.center,)
    );
  }
  Widget logoWidget(){
    return Column(
      children: [
      Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Image.asset('assets/images/litlogo.png'), height: 125,
    ),
        Container(
          child: RichText(
            text: TextSpan(

            )
          )
        )

      ],
    );
  }

  Widget confirmPasswordInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        //password input
        validator: (input){
          if(input.isEmpty){
            return 'confirm your password';
          }
          if(!input.contains(_password)){
            print(input + 'vs' + _password);
            return 'passwords do not match';
          }
          return null;
        },
        onSaved: (input) => _confirm_password = input,
        maxLines: 1,
        minLines: 1,
        maxLength: 16,
        style: infoValue(Theme.of(context).textSelectionColor),
        obscureText: cpObscure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: passwordVisibilityDecorator(confirm_password_label , cpObscure),
        onChanged: (passInput){
            _confirm_password = passInput;
            setState(() {});
        },
      ),
    );
  }

  InputDecoration passwordVisibilityDecorator(String label , bool obscure){
    return new InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility
                : Icons.visibility_off,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: (){_toggle(obscure);},
        ),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1),),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2))
    );
  }
  Widget passwordInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        //password input
        validator: (input){
          if(input.isEmpty){
            return 'enter your password';
          }
          if(input.length < 8){
            return 'password length must be greater than 8';
          }
          return null;
        },
        onSaved: (input) =>   _password  = input,
        maxLines: 1,
        minLines: 1,
        maxLength: 16,
        obscureText: pObscure,
        style: infoValue(Theme.of(context).textSelectionColor),
        cursorColor: Theme.of(context).primaryColor,
        decoration: passwordVisibilityDecorator(password_label , pObscure),
        onChanged: (passInput){
            _password = passInput;
            setState(() {});
        },
      ),
    );
  }
  Widget usernameInput(){
    return  Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        validator: (input){
          if(input.trim().isEmpty){
            return 'enter a valid username';
          }
          if(input.contains(" ")){
            return 'username cannot contain spaces';
          }
          if(input.trim().length < 4 || input.trim().length > 16){
            return 'username must be > 4 and < 16 characters';
          }
          if(input.contains('@') || input.contains('.')){
            return 'Only 0-9 , A-Z and _ , - are allowed.';
          }
          return null;
        },

        onSaved: (input) => _username = input,
        maxLines: 1,
        minLines: 1,
        maxLength: 16,
        style: infoValue(Theme.of(context).textSelectionColor),
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            labelText: username_label,
            suffixIcon: new Icon(Icons.title ,
              color: Theme.of(context).primaryColor,
            ),
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1),),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 2))
        ),
        onChanged: (input){
            _username = input;
            setState(() {});
        },
      ),
    );
  }
  Widget emailInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(15, 35, 15, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        validator: (input){
          if(input.trim().isEmpty){
            return 'please enter your email';
          }
          if(input.contains(" ")){
            return 'please enter a valid email';
          }
          if(!input.contains('@') && !input.contains('.')){
            return 'enter a valid email';
          }
          return null;
        },
        onSaved: (input) => _email  = input,
        onChanged: (input){
            _email = input;
            setState(() {});
        },
        maxLines: 1,
        minLines: 1,
        maxLength: 36,
        style: infoValue(Theme.of(context).textSelectionColor),
        cursorColor: Theme.of(context).primaryColor,
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

  Widget registerButton(){
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: RaisedButton(
            child: Text(register_label ,style: infoValue(Theme.of(context).textSelectionColor),),
            onPressed: (){
              //TODO Implement register
              registerUser();
            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
        )
    );
  }
void registerUser() async {
    //TODO Add user to db as clean object
    final registrationForm = _formKey.currentState;
    if(registrationForm.validate()){
     await rp.registerNewUser(_email, _password, _username).then((value){
       if(value.contains("ERROR")){
         setState(() {
           error = value.split(':')[1];
         });
         return;
       }
      beginSurvey(value);
      });
    }
}
  Widget haveAnAccountText(){
    return Container(
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: GestureDetector(
            onTap: () => { _toLogin() },
            child: Text(existing_account_prompt ,
              style: TextStyle(color: Theme.of(context).indicatorColor ,  fontSize: 16),
            )
        ));
  }
  void _toLogin(){
    Navigator.pushReplacementNamed(context, LoginPageRoute);
  }
  void _toggle(bool val){
    setState(() {
      val = !val;
    });
  }

  void beginSurvey(String userID){
    Navigator.pushReplacementNamed(context, SurveyPageRoute , arguments: userID);
  }
}
