import 'package:flutter/material.dart';
import 'package:runningapp/models/user.dart';

class PodiumWidget extends StatelessWidget {
  final UserModel firstPlace;
  final UserModel secondPlace;
  final UserModel thirdPlace;

  const PodiumWidget({
    super.key,
    required this.firstPlace,
    required this.secondPlace,
    required this.thirdPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildProfileColumn(
            context,
            thirdPlace,
            '3rd',
            Colors.brown,
          ),
        ),
        Expanded(
          child: _buildProfileColumn(
            context,
            firstPlace,
            '1st',
            Colors.yellow[700]!,
          ),
        ),
        Expanded(
          child: _buildProfileColumn(
            context,
            secondPlace,
            '2nd',
            Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileColumn(
      BuildContext context, UserModel profile, String position, Color color) {
    double fontSizePosition;
    double fontSizeName;

    switch (position) {
      case '1st':
        fontSizePosition = 30;
        fontSizeName = 25;
        break;
      case '2nd':
      case '3rd':
        fontSizePosition = 16;
        fontSizeName = 14;
        break;
      default:
        fontSizePosition = 16;
        fontSizeName = 14;
    }

    return Card(
      color: Theme.of(context).colorScheme.secondaryFixed,
      elevation: (position == '1st') ? 10 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              position,
              style: TextStyle(
                fontSize: fontSizePosition,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                backgroundImage: NetworkImage(profile.profilePic),
              ),
            ),
            const SizedBox(height: 8),
            Text(profile.name, style: TextStyle(fontSize: fontSizeName)),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('${profile.points}',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
