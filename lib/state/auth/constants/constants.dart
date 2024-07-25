import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const accountExistsWithDifferentCredentialsError =
      'account-exists-with-different-credential';
  static const googleCom = 'google.com';
  static const emailScope = 'email';
  static const GENERALRUNNINGPLAN = '''
{
  "running_plan": {
    "weeks": [
      {
        "week_number": 1,
        "total_distance_km": 20,
        "running_days": 5,
        "daily_schedule": [
          {
            "day_of_week": "Monday, 29 July",
            "distance_km": 3,
            "type": "Easy run"
          },
          {
            "day_of_week": "Tuesday, 30 July",
            "distance_km": 4,
            "type": "Speed work"
          },
          {
            "day_of_week": "Wednesday, 31 July",
            "distance_km": 0,
            "type": "Rest day"
          },
          {
            "day_of_week": "Thursday, 1 August",
            "distance_km": 3,
            "type": "Easy run"
          },
          {
            "day_of_week": "Friday, 2 August",
            "distance_km": 0,
            "type": "Rest day"
          },
          {
            "day_of_week": "Saturday, 3 August",
            "distance_km": 5,
            "type": "Long run"
          },
          {
            "day_of_week": "Sunday, 4 August",
            "distance_km": 5,
            "type": "Easy run"
          }
        ]
      },
      {
        "week_number": 2,
        "total_distance_km": 25,
        "running_days": 5,
        "daily_schedule": [
          {
            "day_of_week": "Monday, 5 August",
            "distance_km": 4,
            "type": "Easy run"
          },
          {
            "day_of_week": "Tuesday, 6 August",
            "distance_km": 5,
            "type": "Speed work"
          },
          {
            "day_of_week": "Wednesday, 7 August",
            "distance_km": 0,
            "type": "Rest day"
          },
          {
            "day_of_week": "Thursday, 8 August",
            "distance_km": 4,
            "type": "Tempo run"
          },
          {
            "day_of_week": "Friday, 9 August",
            "distance_km": 0,
            "type": "Rest day"
          },
          {
            "day_of_week": "Saturday, 10 August",
            "distance_km": 6,
            "type": "Long run"
          },
          {
            "day_of_week": "Sunday, 11 August",
            "distance_km": 6,
            "type": "Easy run"
          }
        ]
      },
      {
        "week_number": 3,
        "total_distance_km": 30,
        "running_days": 6,
        "daily_schedule": [
          {
            "day_of_week": "Monday, 12 August",
            "distance_km": 5,
            "type": "Easy run"
          },
          {
            "day_of_week": "Tuesday, 13 August",
            "distance_km": 6,
            "type": "Speed work"
          },
          {
            "day_of_week": "Wednesday, 14 August",
            "distance_km": 0,
            "type": "Rest day"
          },
          {
            "day_of_week": "Thursday, 15 August",
            "distance_km": 5,
            "type": "Tempo run"
          },
          {
            "day_of_week": "Friday, 16 August",
            "distance_km": 4,
            "type": "Easy run"
          },
          {
            "day_of_week": "Saturday, 17 August",
            "distance_km": 6,
            "type": "Long run"
          },
          {
            "day_of_week": "Sunday, 18 August",
            "distance_km": 4,
            "type": "Recovery run"
          }
        ]
      }
    ]
  }
}
''';
  const Constants._();
}
