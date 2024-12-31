import 'package:stun_kit/stun_kit.dart';

class ViewModelExampleVM extends AppStateNotifier {
  Future<void> simulateFetching() async {
    try {
      setState(LoadingState());
      await Future.delayed(Duration(seconds: 3));
      setState(InitialState());
    } catch (error, _) {
      setStateByException(error);
    }
  }

  Future<void> simulateFetchingWithError() async {
    try {
      setState(LoadingState());
      await Future.delayed(Duration(seconds: 3));

      throw ApiException(type: ApiExceptionType.other);
    } catch (error, _) {
      setStateByException(error);
    }
  }
}
