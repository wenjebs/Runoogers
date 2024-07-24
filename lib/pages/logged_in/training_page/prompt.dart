class Prompt {
  int timesPerWeek;
  double targetDistance;
  String targetTime;
  int weeksToTrain;
  String age;
  String level;
  String todaysDate;
  String tomorrowsDate;
  String dayAfterTomorrowsDate;
  late final String prompt;

  Prompt({
    required this.timesPerWeek,
    required this.targetDistance,
    required this.targetTime,
    required this.weeksToTrain,
    required this.age,
    required this.level,
    required this.todaysDate,
    required this.tomorrowsDate,
    required this.dayAfterTomorrowsDate,
  }) {
    prompt = """
Design a JSON response structure for a running plan that includes the following details for each week of the plan: what week it is for (e.g., 16-22 May), total weekly distance in kilometers, the number of running days, and a breakdown of each day's run including the day of the week, distance, and whether it's a rest day or a specific training focus (e.g., speed work, long run). Ensure that the JSON format remains consistent for every generated running plan.

Here are all the types of runs that can be included in the daily_schedule: Easy run, Speed work, Long run, Recovery run, Interval training, Rest day.

Generate all days of the week, including the rest day, in the daily_schedule. The rest day should have a distance of 0 and a type of "Rest day".

Generate every single day of the week. Start generating the plan with the first day of the week being the current day of the week. For example, if today is Tuesday, start generating the plan from Tuesday. Generate the plan starting from today's date as well. For example, if today is 16 May, start generating the plan from 16 May. Make sure there are 7 days in a week. The first week starts on today's date and ends on Sunday. Every week starting from week 2 should start on Monday and end on Sunday and have all 7 days of the week generated.

Ensure that each week increases in difficulty gradually. Ensure you generate EVERY day and date of the week. Today's date is $todaysDate.

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
"day_of_week": "16 May",
"distance_km": 5,
"type": "Easy run"
},
{
"day_of_week": "17 May",
"distance_km": 6,
"type": "Speed work"
},
{
"day_of_week": "18 May",
"distance_km": 0,
"type": "Rest day"
},
// ... continue with the rest of the week
]
},
// ... add more weeks as needed
]
}
}

Please provide a JSON object adhering to this structure for a $weeksToTrain-week running plan tailored for a $age-year-old $level runner that can run $timesPerWeek times a week, ensuring each week increases in difficulty gradually. The runner's goal is to run $targetDistance kilometers in $targetTime minutes.

Generate every single day of the week, starting with the current day of the week. If today is Tuesday, start generating the plan from Tuesday. If today is Sunday, start generating the plan from Sunday. If today is Monday, start generating the plan from Monday. If today is Wednesday, start generating the plan from Wednesday. If today is Thursday, start generating the plan from Thursday. If today is Friday, start generating the plan from Friday. If today is Saturday, start generating the plan from Saturday.

For weeks 2 and beyond, make sure to generate ALL DAYS OF THE WEEK, including the rest day, in the daily_schedule, and make sure each week has Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, and Sunday. The rest day should have a distance of 0 and a type of "Rest day".

For week 1, generate the plan starting from today's date. For weeks 2 and beyond, generate the plan starting from Monday of that week.

Ensure that each week increases in difficulty gradually. Ensure you generate EVERY day and date of the week. Today's date is $todaysDate.

Dont include the ```json ``` tag in your response.

""";
  }
}
