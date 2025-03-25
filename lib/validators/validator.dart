import 'package:flutter/cupertino.dart';

abstract class Validator<T> extends ChangeNotifier {
  bool _isValid = true;

  bool get isValid => _isValid;

  bool get isNotValid => !_isValid;

  String? handleMessage(String? message) {
    _isValid = message == null;
    notifyListeners();
    return message;
  }

  String? validate(T? value);
}
