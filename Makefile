.PHONY: test dry-run publish generate_exports all

# Путь к директории, для которой генерируются экспорты.
# По умолчанию используется директория lib, можно переопределить переменной EXPORTS_DIR.
EXPORTS_DIR ?= lib

# Запускает тесты
test:
	@echo "Запуск тестов..."
	flutter test

# Выполняет dry-run публикации
dry-run:
	@echo "Выполняется dry-run публикации..."
	flutter pub publish --dry-run

# Публикует пакет на pub.dev, предварительно запустив тесты и dry-run
publish: test dry-run
	@echo "Публикация пакета на pub.dev..."
	flutter pub publish

# Запускает скрипт generate_exaports.sh, делая его исполняемым и передавая путь к директории
generate_exports:
	@echo "Запуск скрипта ./scripts/generate_exports.sh для директории $(EXPORTS_DIR)..."
	chmod +x ./scripts/generate_exports.sh
	./scripts/generate_exports.sh $(EXPORTS_DIR)

# all: сначала генерирует экспорты, затем публикует пакет (тесты и dry-run выполняются в publish)
all: publish
