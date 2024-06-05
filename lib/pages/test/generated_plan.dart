import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';
import 'package:runningapp/pages/test/chat_input.dart';

class SectionTextStreamInput extends StatefulWidget {
  const SectionTextStreamInput({super.key});

  @override
  State<SectionTextStreamInput> createState() => _SectionTextInputStreamState();
}

class _SectionTextInputStreamState extends State<SectionTextStreamInput> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText,
      // result,
      _finishReason;

  Text result = const Text('nothin here');

  bool loading = false;
  String? get finishReason => _finishReason;

  set finishReason(String? set) {
    if (set != _finishReason) {
      setState(() => _finishReason = set);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (searchedText != null)
            MaterialButton(
                color: Colors.blue.shade700,
                onPressed: () {
                  setState(() {
                    searchedText = null;
                    finishReason = null;
                    // result = null;
                  });
                },
                child: Text('search: $searchedText')),

          Expanded(
            child: SingleChildScrollView(
              child:
                  loading ? Lottie.asset('lib/assets/lottie/ai.json') : result,
            ),
          ),

          // this widget js streams the content
          // Expanded(
          //   child: GeminiResponseTypeView(
          //     builder: (context, child, response, loading) {
          //       if (loading) {
          //         return Lottie.asset('lib/assets/lottie/ai.json');
          //       }

          //       if (response != null) {
          //         return Markdown(
          //           data: response,
          //           selectable: true,
          //         );
          //       } else {
          //         return const Center(child: Text('Search something!'));
          //       }
          //     },
          //   ),
          // ),

          /// if the returned finishReason isn't STOP
          if (finishReason != null) Text(finishReason!),

          /// imported from local widgets
          ChatInputBox(
            controller: controller,
            onSend: () {
              if (controller.text.isNotEmpty) {
                debugPrint('request');

                setState(() {
                  loading = true;
                });
                searchedText = controller.text;
                controller.clear();
                gemini.text("""
Design a JSON response structure for a running plan that includes the following details for each week of the plan: the week number, total weekly distance in kilometers, the number of running days, and a breakdown of each day's run including the day of the week, distance, and whether it's a rest day or a specific training focus (e.g., speed work, long run). Ensure that the JSON format remains consistent for every generated running plan.
Dont include the string json at the start and dont include the ``` at the start and end of the code block
Example of the expected JSON structure:


{
  "running_plan": {
    "weeks": [
      {
        "week_number": 1,
        "total_distance_km": 30,
        "running_days": 5,
        "daily_schedule": [
          {
            "day_of_week": "Monday",
            "distance_km": 5,
            "type": "easy_run"
          },
          {
            "day_of_week": "Tuesday",
            "distance_km": 6,
            "type": "speed_work"
          },
          {"day_of_week": "Wednesday", "distance_km": 0, "type": "rest_day"},
          // ... continue with the rest of the week
        ]
      },
      // ... add more weeks as needed
    ]
  }
}
Please provide a JSON object adhering to this structure for a 4-week running plan tailored for a beginner, ensuring each week increases in difficulty gradually.
""", modelName: 'models/gemini-pro').then((text) => {
                      setState(() {
                        loading = false;
                        final json =
                            jsonDecode(text!.output!) as Map<String, dynamic>;
                        final weeks = json['running_plan']['weeks'] as List;
                        debugPrint(weeks.toString());
                        result = Text(text.output ??
                            'mission failed well get em next time');
                      })
                    });
              }
            },
          )
        ],
      ),
    );
  }
}
