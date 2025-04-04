import 'package:stun_kit/validators/src/required_validator.dart';
import 'package:test/test.dart';

void main() {
  group('RequiredValidator', () {
    test('should return error message for null value', () {
      final validator =
          RequiredValidator<String>('Поле обязательно для заполнения');
      final result = validator.validate(null);

      // Проверяем, что возвращается сообщение об ошибке.
      expect(result, equals('Поле обязательно для заполнения'));
      // Проверяем, что валидатор считает значение невалидным.
      expect(validator.isValid, isFalse);
    });

    test('should return error message for empty string', () {
      final validator =
          RequiredValidator<String>('Поле обязательно для заполнения');
      final result = validator.validate('');

      // Ожидается сообщение об ошибке для пустой строки.
      expect(result, equals('Поле обязательно для заполнения'));
      expect(validator.isValid, isFalse);
    });

    test('should return null for non-empty string', () {
      final validator =
          RequiredValidator<String>('Поле обязательно для заполнения');
      final result = validator.validate('текст');

      // Ожидается отсутствие ошибки при непустом значении.
      expect(result, isNull);
      expect(validator.isValid, isTrue);
    });

    test('should work with different data types', () {
      // Пример использования валидатора для числового значения.
      final intValidator = RequiredValidator<int>('Значение обязательно');

      // Если значение null — возвращается сообщение об ошибке.
      final resultNull = intValidator.validate(null);
      expect(resultNull, equals('Значение обязательно'));
      expect(intValidator.isValid, isFalse);

      // Если значение присутствует — ошибки нет.
      final resultValid = intValidator.validate(123);
      expect(resultValid, isNull);
      expect(intValidator.isValid, isTrue);
    });
  });
}
