class Prompt {
  String get prompt => _prompt;
  final String _prompt = """
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
""";
}
