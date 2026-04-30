import 'package:flutter/material.dart';
import 'package:simple_counter_app/models/counter_model.dart'; 
import 'package:provider/provider.dart';

class CounterProvider extends StatelessWidget {
  final Widget child;

  const CounterProvider({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: child,
    );
  }
}