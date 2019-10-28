import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:peliculas/src/utils/validator.dart';

final Firestore _db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
final _scrollController = ScrollController(); 

  final formKey = GlobalKey<FormState>();
  // Correo electronico del usuario
  String name = '';
  String email = '';
  // Password del usuario
  String password = '';
  // Mostrar password
  bool hide = true;

  FocusNode _userFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _userFocusNode = new FocusNode();
    _emailFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }

  @override
  void dispose() {
    _userFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Center( child: SingleChildScrollView(controller: _scrollController, reverse: false, child: fullContainer()))
      ),
    );
  }

  SafeArea fullContainer() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
           mainAxisSize: MainAxisSize.max,
           mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loginTitle(),
            loginForm()
          ],
        ),
      ),
    );
  }

  Widget loginTitle() {
    return Text(
          'Crea un usuario en Películas',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
    );
  }

  Form loginForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40.0),
          userField(),
          SizedBox(height: 20.0),
          emailField(),
          SizedBox(height: 20.0),
          passwordField(),
          SizedBox(height: 20.0),
           Row(
            children: <Widget>[
              Expanded(child: submitButton()),
            ],
          ),
        ],
      ),
    );
  }

   // Widget de textField para correo electronico
  Widget userField() {
    return TextFormField(
        focusNode: _userFocusNode,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
          labelText: 'Nombre',
          hintText: 'Nombre',
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
        ),
        validator: (input) => FieldValidator.validateName(input),
        textInputAction: TextInputAction.next,
        onSaved: (value) => name = value.trim(),
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(_emailFocusNode),
      );
  }

  // Widget de textField para correo electronico
  Widget emailField() {
    return TextFormField(
      focusNode: _emailFocusNode,
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
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
    );
  }

  Widget passwordField() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
        labelText: 'Password',
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            hide ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              hide = !hide;
            });
          },
        ),
      ),
      validator: (input) => input.length < 6
          ? 'La contraseña debe tener al menos 8 caracteres'
          : null,
      onSaved: (input) => password = input.trim(),
      obscureText: hide,
      onFieldSubmitted: (_) => submit(),
    );
  }

   Widget submitButton() {
    return RaisedButton(
      color: Colors.red,
      textColor: Colors.white,
      shape: StadiumBorder(),
      padding: new EdgeInsets.all(16.0),
      child: Text('Crear usuario'),
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

        final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;

        await user
            .sendEmailVerification()
            .then((onValue) => print('Email de verificacion enviado'))
            .catchError((onError) => print('Error de verificacion $onError'));

        _db.collection('users').document(user.uid).setData({
          'name' : name,
          'email' : email
        }).then((onValue) => _registerComplete()
        ).catchError((onError) => _errorDialog(onError.toString()) );
      } catch (e) {
        _errorDialog(e.toString());
      }
    }
  }
  Future<void> _errorDialog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'.toUpperCase()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerComplete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registro completo'.toUpperCase()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bienvenido a la aplicación de Películas'),
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
                Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
