import 'package:example/ui/screens/paginator_example_widget/paginator_example_vm.dart';
import 'package:example/ui/widgets/page_state.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:stun_kit/stun_kit.dart';

class PaginatorExampleScreen extends StatelessWidget {
  const PaginatorExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PaginatorExampleVM>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paginator Example'),
      ),
      body: LazyLoadScrollView(
        onEndOfPage: vm.fetchTodos,
        scrollOffset: 300,
        isLoading: vm.state is LoadingState,
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _SearchInputWidget(),
              SizedBox(height: 16),
              _ListWidget(),
              SizedBox(height: 16),
              _ViewStateObserverWidget(),
              SafeArea(child: SizedBox(height: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInputWidget extends StatelessWidget {
  const _SearchInputWidget();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<PaginatorExampleVM>();

    return TextFormField(
      decoration: const InputDecoration(
        label: Text('Search'),
      ),
      controller: vm.searchController,
    );
  }
}

class _ListWidget extends StatelessWidget {
  const _ListWidget();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PaginatorExampleVM>();
    final todos = vm.todos;
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.zero,
      itemBuilder: (_, i) {
        final todo = todos[i];
        return ListTile(
          title: Text(todo.title),
          trailing: Text('${todo.id}'),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: todos.length,
    );
  }
}

class _ViewStateObserverWidget extends StatelessWidget {
  const _ViewStateObserverWidget();

  @override
  Widget build(BuildContext context) {
    return AppStateBuilder<PaginatorExampleVM>(
      builder: (vm) {
        if (vm.todos.isNotEmpty) return const SizedBox.shrink();
        return const PageStateWidget.empty();
      },
      loadingState: (_) => const PageStateWidget.loading(),
      apiErrorState: (_, __) => const PageStateWidget.server(),
      badRequestState: (_, __) => const PageStateWidget.badRequest(),
      noInternetState: (_, __) => const PageStateWidget.noInternet(),
      internalState: (_, __) => const PageStateWidget.server(
        title: 'Не придвиденная ошибка',
      ),
    );
  }
}
