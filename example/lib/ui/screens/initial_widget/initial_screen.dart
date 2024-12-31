import 'package:example/ui/navigation/app_router.dart';
import 'package:example/ui/navigation/routes.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  InitialScreen({super.key});

  final _buttons = [
    OutlinedButton(
      onPressed: () {
        AppRouter.pushNamed(AppRoutes.viewModelExample);
      },
      child: Text('ViewModel Example'),
    ),
    OutlinedButton(
      onPressed: () {
        AppRouter.pushNamed(AppRoutes.viewModelExample);
      },
      child: Text('Storyboard'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stun Kit Example'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        separatorBuilder: (_, i) => SizedBox(height: 16),
        itemBuilder: (_, i) => _buttons[i],
        itemCount: _buttons.length,
      ),
    );
  }
}
