import 'package:flutter/cupertino.dart';
import 'package:stun_kit/models/exceptions/api_exception.dart';
import 'app_state.dart';

class AppStateNotifier extends ChangeNotifier {
  AppState _state = InitialState();
  AppState get state => _state;

  void setState(AppState state, [bool silent = false]) {
    if (_state == state) return;
    _state = state;

    if (silent) return;
    notifyListeners();
  }

  void setStateByException(Object exception) {
    if (exception is ApiException) {
      switch (exception.type) {
        case ApiExceptionType.auth:
        case ApiExceptionType.other:
          setState(ApiErrorState(exception));
          break;
        case ApiExceptionType.badRequest:
          setState(BadRequestState(exception));
          break;
        case ApiExceptionType.timeout:
          setState(NoInternetState(exception));
          break;
      }
    } else {
      setState(InternalErrorState(exception));
    }
  }
}
