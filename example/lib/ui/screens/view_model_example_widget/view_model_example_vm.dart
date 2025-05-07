import 'package:flutter/cupertino.dart';
import 'package:stun_kit/stun_kit.dart';

class ViewModelExampleVM extends ChangeNotifier with AppStateManager {
  @override
  final ExceptionService exceptionService;

  ViewModelExampleVM({required this.exceptionService});

  Future<void> simulateFetching() async {
    try {
      setState(const LoadingState());
      await Future.delayed(const Duration(seconds: 3));
      setState(const InitialState());
    } catch (error, _) {
      setStateByException(error);
    }
  }

  Future<void> simulateFetchingWithError() async {
    try {
      setState(const LoadingState());
      await Future.delayed(const Duration(seconds: 3));

      throw ApiException(type: ApiExceptionType.other);
    } catch (error, _) {
      setStateByException(error);
    }
  }
}
