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
        title: const Text('ViewModel Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ViewStateObserverWidget(),
            const SizedBox(height: 16),
            _StateDropDownWidget(),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: vm.simulateFetching,
              child: const Text('Simulate Fetching'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: vm.simulateFetchingWithError,
              child: const Text('Simulate Fetching With Error'),
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
    'InitialState': const InitialState(),
    'LoadingState': const LoadingState(),
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
          builder: (_) => const PageStateWidget(
            title: 'Это состояние никогда не отобразится',
          ),
          initialState: (_) => const PageStateWidget(
            title: 'Стартовое состояние',
          ),
          loadingState: (_) => const PageStateWidget.loading(),
          apiErrorState: (_, __) => const PageStateWidget.server(),
          badRequestState: (_, __) => const PageStateWidget.badRequest(),
          noInternetState: (_, __) => const PageStateWidget.noInternet(),
          internalState: (_, __) => const PageStateWidget.server(
            title: 'Не придвиденная ошибка',
          ),
        ),
      ),
    );
  }
}
