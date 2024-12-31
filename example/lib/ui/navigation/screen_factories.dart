import 'package:auto_route/auto_route.dart';
import 'package:example/ui/screens/initial_widget/initial_screen.dart';
import 'package:example/ui/screens/view_model_example_widget/view_model_example_screen.dart';
import 'package:example/ui/screens/view_model_example_widget/view_model_example_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class InitialScreenFactory extends StatelessWidget {
  const InitialScreenFactory({super.key});

  @override
  Widget build(BuildContext context) {
    return InitialScreen();
  }
}

@RoutePage()
class ViewModelExampleScreenFactory extends StatelessWidget {
  const ViewModelExampleScreenFactory({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ViewModelExampleVM(),
      child: const ViewModelExampleScreen(),
    );
  }
}
