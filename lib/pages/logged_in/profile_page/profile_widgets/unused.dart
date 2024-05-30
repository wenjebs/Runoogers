import 'package:flutter/material.dart';

class ignore extends StatelessWidget {
  const ignore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Progress"),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(),
                child: const Text(
                    "Distance: 100km"), // TODO : MAKE IT FROM DATABASE!!!!!
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(
                    width: 20, thickness: 1, color: Colors.teal),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const Text(
                    "Calories: 1.5kcal"), // TODO : MAKE IT FROM DATABASE!!!!!
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(
                    width: 20, thickness: 1, color: Colors.teal),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const Text(
                    "Time: 121hrs"), // TODO : MAKE IT FROM DATABASE!!!!!
              ),
            ],
          ),
        ],
      ),
    );
  }
}
