import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/chosen_state.dart';

class RunAchievementButton extends ConsumerWidget {
  const RunAchievementButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIndexProvider);
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary,
            width: 2,
          ),
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(90),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTab(
                index: 0, text: 'Achievements', ref: ref, context: context),
            _buildTab(index: 1, text: 'Runs', ref: ref, context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      {required int index,
      required String text,
      required WidgetRef ref,
      required BuildContext context}) {
    int selected = ref.read(selectedIndexProvider);
    return GestureDetector(
      onTap: () => {
        ref.read(selectedIndexProvider.notifier).state = index,
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          color: selected == index
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(90),
        ),
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Text(text,
              style: TextStyle(
                  color: selected == index
                      ? Colors.black
                      : const Color.fromARGB(255, 0, 0, 0))),
        ),
      ),
    );
  }
}
