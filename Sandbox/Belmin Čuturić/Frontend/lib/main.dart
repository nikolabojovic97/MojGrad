import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Simple Login Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green
      ),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _cityFilter = new TextEditingController();
  final TextEditingController _addresFilter = new TextEditingController();
  final TextEditingController _streetFilter = new TextEditingController();
  final TextEditingController _phoneFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  String _city = "";
  String _novi ="";
  String _addres = "";
  String _street = "";
  String _phone ="";
  FormType _form = FormType.login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
    _cityFilter.addListener(_cityListen);  
    _addresFilter.addListener(_addresListen); 
    _streetFilter.addListener(_streetListen);
    _phoneFilter.addListener(_phoneListen);          
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }
  void _cityListen()
  {
    if(_cityFilter.text.isEmpty)
    {
      _city="";
    }
    else{
      _city = _cityFilter.text;
    }
  }
  void _addresListen()
  {
    if(_addresFilter.text.isEmpty)
    {
      _addres="";
    }
    else{
      _addres = _addresFilter.text;
    }
  }
  void _streetListen()
  {
    if(_streetFilter.text.isEmpty)
    {
      _street="";
    }
    else{
      _street = _streetFilter.text;
    }
  }
  void _phoneListen()
  {
    if(_phoneFilter.text.isEmpty)
    {
      _phone="";
    }
    else{
      _phone = _phoneFilter.text;
    }
  }
  // Swap in between our two forms, registering and logging in
  void _formChange () async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    if(_form == FormType.login)
    {
      _novi = "Login";
    }
    else
    {
      _novi = "Register";
    }
        return new AppBar(
            title: new Text (_novi),
        centerTitle: true,
    );
    
  }

  Widget _buildTextFields() {
    if(_form == FormType.login)
    {
      return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                labelText: 'Email'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                labelText: 'Password'
              ),
              obscureText: true,
            ),
          ),
          ],
          ),
      );
    }
    else
    {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                labelText: 'Email'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                labelText: 'Password'
              ),
              obscureText: true,
            ),
          ),
          new Container(
            child: new TextField(
              controller: _cityFilter,
              decoration: new InputDecoration(
                labelText: 'City'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _addresFilter,
              decoration: new InputDecoration(
                labelText: 'Addres'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _streetFilter,
              decoration: new InputDecoration(
                labelText: 'Street'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _phoneFilter,
              decoration: new InputDecoration(
                labelText: 'Phone'
              ),
            ),
          )
        ],
      ),
    );
    }
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
            ),
            new FlatButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new FlatButton(
              child: new Text('Forgot Password?'),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            new FlatButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password

  void _loginPressed () {
    print('The user wants to login with $_email and $_password and $_city and $_addres $_phone');
  }

  void _createAccountPressed () {
    print('The user wants to create an accoutn with $_email and $_password and $_city and $_addres');

  }

  void _passwordReset () {
    print("The user wants a password reset request sent to $_email and $_city and $_addres $_street");
  }


}