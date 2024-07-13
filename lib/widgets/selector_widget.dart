import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/game_data_provider.dart';

abstract class SelectorWidget extends StatefulWidget {
  final List<String> options;

  const SelectorWidget(this.options, {super.key});

  @override
  SelectorWidgetState createState();
}

abstract class SelectorWidgetState<T extends SelectorWidget> extends State<T> {
  int selectedValue = 0;

  void onSelected(int index);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.options.asMap().entries.map((entry) {
            int index = entry.key;
            String label = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ChoiceChip(
                label: Text(label),
                selected: selectedValue == index,
                onSelected: (selected) {
                  setState(() {
                    selectedValue = index;
                  });
                  onSelected(index);
                },
                selectedColor: Colors.lightBlue,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedValue == index ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
