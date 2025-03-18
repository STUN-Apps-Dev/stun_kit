import 'package:example/ui/router/app_router.dart';
import 'package:example/ui/router/routes.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  InitialScreen({super.key});

  final _buttons = [
    OutlinedButton(
      onPressed: () {
        AppRouter.pushNamed(AppRoutes.viewModelExample);
      },
      child: const Text('ViewModel Example'),
    ),
    OutlinedButton(
      onPressed: () {
        AppRouter.pushNamed(AppRoutes.paginatorExample);
      },
      child: const Text('Paginator Example'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stun Kit Example'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, i) => const SizedBox(height: 16),
        itemBuilder: (_, i) => _buttons[i],
        itemCount: _buttons.length,
      ),
    );
  }
}
