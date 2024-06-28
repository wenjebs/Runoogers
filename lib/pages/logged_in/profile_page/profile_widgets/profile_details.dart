import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  final String name;
  const ProfileDetails({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
                child: Text(
                  'TODO username here', // TODO fetch username from db
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
