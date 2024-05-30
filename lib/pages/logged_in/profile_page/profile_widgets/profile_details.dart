import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
          child: Text(
            style: Theme.of(context).textTheme.headlineLarge,
            'James Jameson', // TODO FROM DATABASE
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
          child: Text(
            'I love running bro',
          ),
        )
      ],
    );
  }
}
