import 'package:example/ui/screens/view_model_example_widget/view_model_example_vm.dart';
import 'package:example/ui/widgets/page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stun_kit/stun_kit.dart';

class ViewModelExampleScreen extends StatelessWidget {
  const ViewModelExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ViewModelExampleVM>();
    return Scaffold(
      appBar: AppBar(
        title: Text('ViewModel Example'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ViewStateObserverWidget(),
            SizedBox(height: 16),
            _StateDropDownWidget(),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: vm.simulateFetching,
              child: Text('Simulate Fetching'),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: vm.simulateFetchingWithError,
              child: Text('Simulate Fetching With Error'),
            )
          ],
        ),
      ),
    );
  }
}

class _StateDropDownWidget extends StatelessWidget {
  static final _exception = ApiException(type: ApiExceptionType.other);

  final _states = {
    'InitialState': InitialState(),
    'LoadingState': LoadingState(),
    'ApiErrorState': ApiErrorState(_exception),
    'BadRequestState': BadRequestState(_exception),
    'NoInternetState': NoInternetState(_exception),
    'InternalErrorState': InternalErrorState(_exception),
  };

  _StateDropDownWidget();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ViewModelExampleVM>();
    return DropdownButton(
      value: '${vm.state.runtimeType}',
      items: _states.keys.map((key) {
        return DropdownMenuItem(
          value: key,
          child: Text(key),
        );
      }).toList(),
      onChanged: (key) {
        final state = _states[key];
        if (state == null) return;
        vm.setState(state);
      },
    );
  }
}

class _ViewStateObserverWidget extends StatelessWidget {
  const _ViewStateObserverWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 3,
        ),
        child: AppStateBuilder<ViewModelExampleVM>(
          builder: () => PageStateWidget(
            title: 'Это состояние никогда не отобразится',
          ),
          initialState: () => PageStateWidget(
            title: 'Стартовое состояние',
          ),
          loadingState: () => PageStateWidget.loading(),
          apiErrorState: (_) => PageStateWidget.server(),
          badRequestState: (_) => PageStateWidget.badRequest(),
          noInternetState: (_) => PageStateWidget.noInternet(),
          internalState: (_) => PageStateWidget.server(
            title: 'Не придвиденная ошибка',
          ),
        ),
      ),
    );
  }
}
