import 'package:stun_kit/validators/validator.dart';

class RequiredValidator<T> extends Validator<T> {
  final String message;
  RequiredValidator(this.message);

  @override
  String? validate(T? value) {
    if (value == null || '$value'.isEmpty) {
      return handleMessage(message);
    } else {
      return handleMessage(null);
    }
  }
}
