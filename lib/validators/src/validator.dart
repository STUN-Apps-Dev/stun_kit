import 'package:flutter/cupertino.dart';

/// Абстрактный класс Validator, расширяющий ChangeNotifier для обновления UI при изменении состояния валидации.
/// Параметр T задаёт тип проверяемого значения.
abstract class Validator<T> extends ChangeNotifier {
  // Приватное поле, хранящее текущее состояние валидности.
  bool _isValid = true;

  // Геттер, возвращающий текущее состояние валидности.
  bool get isValid => _isValid;

  // Геттер, возвращающий инвертированное состояние валидности (удобно для проверки невалидности).
  bool get isNotValid => !_isValid;

  /// Метод handleMessage обновляет состояние валидности.
  /// Если message равно null, значение считается валидным.
  /// После обновления вызывается notifyListeners для информирования подписчиков об изменении.
  /// Возвращает переданное сообщение.
  String? handleMessage(String? message) {
    _isValid = message == null;
    notifyListeners();
    return message;
  }

  /// Абстрактный метод validate, который необходимо реализовать в наследниках.
  /// Он должен проверять значение и возвращать сообщение об ошибке (если имеется) или null.
  String? validate(T? value);
}
