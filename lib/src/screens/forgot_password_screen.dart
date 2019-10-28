import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/utils/validator.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  
  final formKey = GlobalKey<FormState>();
  // Correo electronico del usuario
  String email = '';

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildHeader(),
            loginForm()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Reset Password', style: TextStyle(color: Colors.red, fontSize: 20.0)),
        Text('Ingresa tu correo electronico y te ayudaremos a reiniciar tu password', style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
      ],
    );

  }

  Widget loginForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40.0),
          emailField(),
          SizedBox(height: 40.0),
          Row(
            children: <Widget>[
              Expanded(child: submitButton()),
            ],
          )
        ],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
        labelText: 'email',
        hintText: 'email',
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (input) => FieldValidator.validateEmail(input),
      textInputAction: TextInputAction.next,
      onSaved: (value) => email = value.trim(),
    );
  }

   Widget submitButton() {
    return RaisedButton(
      color: Colors.red,
      textColor: Colors.white,
      shape: StadiumBorder(),
      padding: new EdgeInsets.all(16.0),
      child: Text('Enviar correo'),
      onPressed: () {
        submit();
      },
    );
  }

  Future submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      // Pasamos el estado a que estamos haciendo el request
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.sendPasswordResetEmail(email: email);
        _forgotPasswordComplete();
      } catch (e) {
        print('---> Error ${e.toString()}');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _forgotPasswordComplete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'.toUpperCase()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Te hemos enviado un correo con las instrucciones para que puedas reiniciar tu password'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'.toUpperCase()),
              onPressed: () {
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}