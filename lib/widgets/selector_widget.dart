import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/game_data_provider.dart';

abstract class SelectorWidget extends StatefulWidget {
  final List<String> options;
  final List<String> images; // 이미지 경로 추가
  final double buttonWidth;

  const SelectorWidget(this.options, this.images, this.buttonWidth, {super.key});

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
            String image = widget.images[index]; // 이미지 경로 가져오기
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SizedBox(
                width: widget.buttonWidth, // 폭을 동일하게 설정
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedValue = index;
                    });
                    onSelected(index);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: selectedValue == index ? Colors.lightBlue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(image, height: 50.0), // 이미지 추가
                        SizedBox(height: 5.0),
                        Text(
                          label,
                          style: TextStyle(
                            color: selectedValue == index ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
