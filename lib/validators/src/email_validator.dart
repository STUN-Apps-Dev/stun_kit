import 'package:stun_kit/validators/src/validator.dart';

/// Валидатор для проверки корректности email-адреса пользователя.
/// При обнаружении ошибки (пустая строка или неверный формат) возвращается единое сообщение об ошибке.
class EmailValidator extends Validator<String> {
  /// Сообщение об ошибке, которое возвращается при невалидном значении.
  final String message;

  /// Регулярное выражение для проверки формата email.
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  /// Конструктор валидатора с параметром [message].
  EmailValidator(this.message);

  /// Метод валидации email.
  ///
  /// Если [value] пустое или не соответствует формату email, возвращается [message].
  /// При корректном значении возвращается `null`.
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty || !emailRegExp.hasMatch(value)) {
      return handleMessage(message);
    }
    return handleMessage(null);
  }
}
