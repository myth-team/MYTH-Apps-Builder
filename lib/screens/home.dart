import 'package:flutter/material.dart';
import 'package:simple_counter_app/models/counter_model.dart'; 
import 'package:simple_counter_app/utils/colors.dart'; 
import 'package:simple_counter_app/widgets/counter_button.dart'; 
import 'package:simple_counter_app/widgets/counter_display.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CounterModel _counterModel;

  @override
  void initState() {
    super.initState();
    _counterModel = CounterModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Simple Counter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.15),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ListenableBuilder(
                      listenable: _counterModel,
                      builder: (context, child) {
                        return CounterDisplay(
                          counterModel: _counterModel,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CounterButton(
                      type: CounterButtonType.decrement,
                      onPressed: () {
                        _counterModel.decrement();
                      },
                    ),
                    CounterButton(
                      type: CounterButtonType.reset,
                      onPressed: () {
                        _counterModel.reset();
                      },
                    ),
                    CounterButton(
                      type: CounterButtonType.increment,
                      onPressed: () {
                        _counterModel.increment();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}