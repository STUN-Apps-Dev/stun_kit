#!/bin/bash
set -euo pipefail

# Цвета для сообщений
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Без цвета

# Функция для логирования с временными метками
log() {
    local type="$1"
    local message="$2"
    local color="$3"

    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] [$type] $message${NC}"
}

# Проверка, что на вход подана одна папка
if [ "$#" -ne 1 ]; then
    log "Ошибка" "Неверное количество аргументов." "$RED"
    echo -e "Использование: $0 <путь_к_директории>"
    exit 1
fi

# Получаем путь к папке и название файла экспорта
directory="$1"
export_file="$directory/$(basename "$directory").dart"

# Проверяем, что указанный путь - папка
if [ ! -d "$directory" ]; then
    log "Ошибка" "Указанный путь '$directory' не является директорией." "$RED"
    exit 1
fi

# Проверка доступности директории
if [ ! -r "$directory" ] || [ ! -w "$directory" ]; then
    log "Ошибка" "Директория '$directory' должна быть доступна для чтения и записи." "$RED"
    exit 1
fi

# Создаём или очищаем файл экспорта и добавляем директиву library
{
    echo "// Автоматически сгенерированные экспорты"
    echo "library;"
    echo ""
} > "$export_file"

log "Информация" "Создан или очищен файл экспорта: $export_file" "$GREEN"

# Рекурсивно находим все файлы с расширением .dart, исключая *.g.dart и сам файл экспорта
# Используем -print0 и read с -d '' для безопасной обработки имен файлов с пробелами
find "$directory" -type f -name "*.dart" ! -name "*.g.dart" ! -path "$export_file" -print0 | sort -z | while IFS= read -r -d '' file; do
    # Получаем относительный путь от указанной директории
    relative_path="${file#$directory/}"
    echo "export '$relative_path';" >> "$export_file"
    log "Экспорт" "Добавлен файл: $relative_path" "$YELLOW"
done

log "Успех" "Файл экспорта успешно сгенерирован: $export_file" "$GREEN"
