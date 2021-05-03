import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is valid. Email: $_email, password: $_password');
    } else {
      print('Form is invalid');
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.blueAccent,
      /*appBar: new AppBar(
        title: new Text('Flutter login'),
        backgroundColor: Colors.blueAccent,
      ),*/
      body: new Container(
        padding: EdgeInsets.all(34),
        child: new Form(
          key: formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        new Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5)),
          validator: (value) => value.isEmpty ? 'Email field is empty' : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(
          height: 10,
        ),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5)),
          obscureText: true,
          validator: (value) =>
              value.isEmpty ? 'Password field is empty' : null,
          onSaved: (value) => _password = value,
        ),
        SizedBox(
          height: 10,
        ),
      ];
    } else {
      return [
        new Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Name',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5)),
          validator: (value) => value.isEmpty ? 'Name field is empty' : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(
          height: 10,
        ),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Last Name',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5)),
          validator: (value) =>
              value.isEmpty ? 'Last Name field is empty' : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(
          height: 10,
        ),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5)),
          validator: (value) => value.isEmpty ? 'Email field is empty' : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(
          height: 10,
        ),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5)),
          obscureText: true,
          validator: (value) =>
              value.isEmpty ? 'Password field is empty' : null,
          onSaved: (value) => _password = value,
        ),
        SizedBox(
          height: 10,
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text(
            'Login',
            style: new TextStyle(fontSize: 20),
          ),
          onPressed: validateAndSave,
        ),
        new FlatButton(
          child: new Text(
            'Create an a account',
            style: new TextStyle(fontSize: 20),
          ),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text(
            'Create an account',
            style: new TextStyle(fontSize: 20),
          ),
          onPressed: validateAndSave,
        ),
        new FlatButton(
          child: new Text(
            'Have an account? Login',
            style: new TextStyle(fontSize: 20),
          ),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
