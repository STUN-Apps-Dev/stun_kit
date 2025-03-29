import 'package:stun_kit/validators/validator.dart';

/// Класс RequiredValidator предназначен для проверки обязательности наличия значения.
/// Наследуется от Validator и реализует метод валидации для проверки на null или пустое значение.
class RequiredValidator<T> extends Validator<T> {
  // Сообщение об ошибке, которое возвращается, если значение не проходит валидацию.
  final String message;

  /// Конструктор, принимающий сообщение об ошибке.
  RequiredValidator(this.message);

  /// Метод validate проверяет, что значение не является null и не является пустой строкой.
  /// Если проверка не пройдена, вызывается handleMessage с сообщением об ошибке,
  /// иначе – с null, что указывает на отсутствие ошибок.
  @override
  String? validate(T? value) {
    if (value == null || '$value'.isEmpty) {
      return handleMessage(message);
    } else {
      return handleMessage(null);
    }
  }
}
