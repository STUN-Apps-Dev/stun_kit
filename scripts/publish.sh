#!/bin/bash
# Скрипт для запуска тестов и публикации пакета на pub.dev

# Запуск тестов
echo "Запуск тестов..."
dart test
if [ $? -ne 0 ]; then
  echo "Тесты не пройдены. Публикация отменена."
  exit 1
fi

# Выполнение dry-run публикации (проверка пакета без фактической публикации)
echo "Выполняется предварительный dry-run публикации..."
flutter pub publish --dry-run
if [ $? -ne 0 ]; then
  echo "Dry-run публикации не пройден. Публикация отменена."
  exit 1
fi

# Публикация пакета на pub.dev
echo "Публикация пакета на pub.dev..."
flutter pub publish
