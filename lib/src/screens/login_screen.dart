import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:peliculas/src/utils/validator.dart';

final Firestore _db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scrollController = ScrollController();

  final formKey = GlobalKey<FormState>();
  // Correo electronico del usuario
  String email = '';
  // Password del usuario
  String password = '';
  // Mostrar password
  bool hide = true;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
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
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  reverse: false,
                  child: fullContainer(),
                ),
              ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            loginTitle(),
            loginForm(),
          ],
        ),
      ),
    );
  }

  Widget loginTitle() {
    return Text(
      'Bienvenido de nuevo',
      style: TextStyle(
        fontSize: 24.0,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
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
          SizedBox(height: 20.0),
          passwordField(),
          SizedBox(height: 40.0),
          Row(
            children: <Widget>[
              Expanded(child: submitButton()),
            ],
          ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('password'),
            child: Text('Olvide mi contraseña', style: TextStyle(color: Colors.white))),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('register'),
            child: Text('Crear un usuario', style: TextStyle(color: Colors.white)))
        ],
      ),
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
      child: Text('Iniciar Sesion'),
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
        final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        // Base de datos
        var docRef = _db.collection('users').document(user.uid);
        docRef.get().then((document) => validate(document));
      } catch (e) {
        print('---> Error ${e.toString()}');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  validate(DocumentSnapshot document) {
    if (document.exists) {
      Navigator.of(context).pushReplacementNamed('home');
    } else {
      print('No hay datos relacionados al usuario');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
