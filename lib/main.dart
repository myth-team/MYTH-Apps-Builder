import 'package:flutter/material.dart';
import 'package:simple_counter_app/screens/home.dart'; 
import 'package:simple_counter_app/providers/counter_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      child: MaterialApp(builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(top: 44.0, bottom: 34.0)), child: child!), 
        title: 'Simple Counter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const HomeScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}