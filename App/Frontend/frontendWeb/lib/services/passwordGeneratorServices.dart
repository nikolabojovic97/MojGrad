import 'dart:math';

String generatePassword(bool _isWithLetters, bool _isWithUppercase, bool _isWithNumbers, bool _isWithSpecial, double _numberCharPassword) {
  String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String _numbers = "0123456789";
  String _special = "@#=+!£\$%&?[](){}";

  String _allowedChars = "";

  _allowedChars += (_isWithLetters ? _lowerCaseLetters : '');
  _allowedChars += (_isWithUppercase ? _upperCaseLetters : '');
  _allowedChars += (_isWithNumbers ? _numbers : '');
  _allowedChars += (_isWithSpecial ? _special : '');

  int i = 0;
  String _result = "";

  // Create password
  while (i < _numberCharPassword.round()) {
    // Get random int
    int randomInt = Random.secure().nextInt(_allowedChars.length);
    // Get random char and append it to the password
    _result += _allowedChars[randomInt];
    i++;
  }

  return _result;
}