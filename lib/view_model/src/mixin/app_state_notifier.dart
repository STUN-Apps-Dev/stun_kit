import 'package:flutter/cupertino.dart';
import 'package:stun_kit/models/exceptions/api_exception.dart';
import 'package:stun_kit/view_model/src/models/app_state.dart';

class AppStateNotifier extends ChangeNotifier {
  AppState _state = InitialState();
  AppState get state => _state;

  bool _mounted = true;

  void setState(AppState state) {
    if (_state == state || !_mounted) return;
    _state = state;
    notifyListeners();
  }

  void setStateSilent(AppState state) {
    if (_state == state) return;
    _state = state;
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

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}
