# Stun Kit

Пакет Flutter с общими архитектурными классами для упрощения разработки и организации приложений.

## Локализация
Please refer to the documentation in English at this [link](https://github.com/STUN-Apps-Dev/stun_kit/blob/main/README.md).

## Начало работы

Добавьте следующую строку в секцию `dependencies` вашего `pubspec.yaml`:
```yaml
dependencies:
  stun_kit: <latest-version>
```
После этого выполните команду:
```shell
flutter pub get
```

## Примеры использования

## ViewModel

Архитектурная концепция подразумевает следующие тезизы:
- Если на экране выполняются какие-то действия, то для него создаётся `ViewModel`.
- В классе `ViewModel` описываются методы, хранится состояние, которое применяется на экране.
- `ViewModel` может быть унаследована от `ChangeNotifier` (опционально).
- У `ViewModel` может быть состояние (`AppState`) (опционально).
- Для подключения состояния необходимо унаследовать `ViewModel` от `AppStateNotifier`.

### AppState
`AppState` — базовый класс для состояния экрана.

От него наследуются базовые состояния.

**Cписок базовых состояний:**
- `InitialState` — стартовое состояние
- `LoadingState` — загрузка
- `ApiErrorState` — ошибка связанная с заполнением данных
- `BadRequestState` — страница не найдена (404)
- `NoInternetState` — таймаут, нет интернета
- `InternalErrorState` — непредвиденная ошибка

### AppStateNotifier
Это миксин для `ViewModel`, отвечающий за установку одного из базовых состояний. Наследуется от `ChangeNotifier`.

Для установки состояния миксин предоставляет несколько методов.

**Список методов:**
- `setState(AppState)` — устанавливает состояние экрана
- `setStateSilent(AppState)` — устанавливает состояние экрана без вызова `notifyListeners()`
- `setStateByException(Object)` — устанавливает состояние в зависимости от ошибки переданной в аргументах

### AppStateBuilder
`AppStateBuilder` используется для отображения интерфейса в зависимости от состояния экрана.

**Аргументы конструктора:**

```dart
  const AppStateBuilder({
    super.key,
    required this.builder,
    this.initialState,
    this.loadingState,
    this.apiErrorState,
    this.badRequestState,
    this.noInternetState,
    this.internalState,
  });
```

`builder` вызывается если установлено состояние, но для этого состояния не определен виджет.

**Пример**: `loadingState` == `null`, тогда вызывается `builder`.



## Пример
Полный пример использования доступен в папке [example/](https://github.com/STUN-Apps-Dev/stun_kit)).