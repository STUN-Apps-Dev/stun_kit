import 'package:stun_kit/validators/src/email_validator.dart';
import 'package:test/test.dart';

void main() {
  group('EmailValidator', () {
    const errorMessage = 'Введите корректный email';
    final validator = EmailValidator(errorMessage);

    test('should return error message when email is null', () {
      final result = validator.validate(null);
      expect(result, equals(errorMessage));
      expect(validator.isValid, isFalse);
    });

    test('should return error message when email is empty', () {
      final result = validator.validate('');
      expect(result, equals(errorMessage));
      expect(validator.isValid, isFalse);
    });

    test('should return error message for invalid email format', () {
      final result = validator.validate('invalid-email');
      expect(result, equals(errorMessage));
      expect(validator.isValid, isFalse);
    });

    test('should return null for valid email: user@example.com', () {
      final result = validator.validate('user@example.com');
      expect(result, isNull);
      expect(validator.isValid, isTrue);
    });

    test('should return null for valid email: example31223@example.com', () {
      final result = validator.validate('example31223@example.com');
      expect(result, isNull);
      expect(validator.isValid, isTrue);
    });

    test('should return null for valid email: example.example@example.com', () {
      final result = validator.validate('example.example@example.com');
      expect(result, isNull);
      expect(validator.isValid, isTrue);
    });

    // Дополнительные тесты на нестандартные случаи
    test(
        'should return error message for email with invalid domain: example@.com',
        () {
      final result = validator.validate('example@.com');
      expect(result, equals(errorMessage));
      expect(validator.isValid, isFalse);
    });

    test(
        'should return error message for email with missing dot in domain: example@com',
        () {
      final result = validator.validate('example@com');
      expect(result, equals(errorMessage));
      expect(validator.isValid, isFalse);
    });

    test(
        'should return error message for email with too long TLD: example@example.technology',
        () {
      final result = validator.validate('example@example.technology');
      expect(result, equals(errorMessage));
      expect(validator.isValid, isFalse);
    });

    // Проверка на email с символами, которые не поддерживаются текущим регулярным выражением
    // Например, знак '+' в имени пользователя не поддерживается данным regex.
    test(
        'should return error message for email with unsupported characters: user.name+tag@example.co.uk',
        () {
      final result = validator.validate('user.name+tag@example.co.uk');
      expect(result, equals(errorMessage));
      expect(validator.isValid, isFalse);
    });
  });
}
