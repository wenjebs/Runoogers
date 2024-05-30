import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RunAchievementButton extends StatefulWidget {
  const RunAchievementButton({super.key});

  @override
  RunAchievementButtonState createState() => RunAchievementButtonState();
}

class RunAchievementButtonState extends State<RunAchievementButton> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFD1D1D1),
          borderRadius: BorderRadius.circular(90),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTab(index: 0, text: 'Achievements'),
            _buildTab(index: 1, text: 'Runs'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({required int index, required String text}) {
    return GestureDetector(
      onTap: () => _selectedIndex.value = index,
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, value, child) {
          return Animate(
            effects: [
              SlideEffect(
                  duration: 500.ms,
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0)),
            ],
            child: Container(
              width: MediaQuery.of(context).size.width * 0.43,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: value == index ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(90),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Text(text),
              ),
            ),
          );
        },
      ),
    );
  }
}
