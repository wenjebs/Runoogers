import 'package:intl/intl.dart';

class Reprompt {
  String originalPlanJson;
  double averageDifficulty;
  late final String prompt;

  Reprompt({
    required this.originalPlanJson,
    required this.averageDifficulty,
  }) {
    String difficulty = difficultyDescription(averageDifficulty);
    String currentDate = getCurrentDateFormatted();
    prompt = """
You are given a JSON for a running plan that includes the following details for each week of the plan: what week it is for (eg. 16-22 May), total weekly distance in kilometers, the number of running days, and a breakdown of each day's run including the day of the week, distance, and whether it's a rest day or a specific training focus (e.g., speed work, long run). 

The JSON is as follows:
$originalPlanJson

The user has found the previous runs before $currentDate to be $difficulty and wants to modify the difficulty of the future runs after the current date accordingly. Modify the difficulty of the future runs in the JSON to make it just right for the user, given that they feel that the previous runs were $difficulty, and return the modified plan as a JSON response following the same structure. The JSON file should be complete, and only the "distance_km" and "type" of the JSON should be modified. The number of entries in the JSON should NOT be modified.

Ensure that the JSON format remains consistent for every modified running plan, and only modify runs after the current date ($currentDate). To modify a run, just adjust "distance_km" and "type" based on the average difficulty of the previous runs.



Dont include the string json at the start and dont include the ``` at the start and end of the code block.
Here are all the types of runs that can be included in the daily_schedule: Easy run, Speed work, Long run, Recovery run, Interval training, Rest day.
Ensure that the JSON format remains consistent for every generated running plan, and return the same JSON with only the 'type' and 'distance_km' modified for each day.
""";
  }

  String getCurrentDateFormatted() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM').format(now);
    return formattedDate;
  }

  String difficultyDescription(double rating) {
    if (rating >= 1.0 && rating < 1.5) {
      return 'extremely challenging';
    } else if (rating >= 1.5 && rating < 2.5) {
      return 'slightly challenging';
    } else if (rating >= 2.5 && rating < 3.5) {
      return 'average';
    } else if (rating >= 3.5 && rating < 4.5) {
      return 'slightly easy';
    } else if (rating >= 4.5 && rating <= 5.0) {
      return 'extremely easy';
    } else {
      return 'Invalid rating';
    }
  }
}
