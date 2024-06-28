import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          // BACKGROUND IMAGE CONTAINER
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: NetworkImage(
            //       'https://images.unsplash.com/photo-1434394354979-a235cd36269d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fG1vdW50YWluc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
            //     ), // To BE CHANGED FROM DATABASE
            //   ),
            // ),
          ),

          // PROFILE IMAGE CONTAINER
          // Align(
          //   alignment: const AlignmentDirectional(0, 1),
          //   child: Padding(
          //     padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          //     child: Container(
          //       width: 130,
          //       height: 130,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         border: Border.all(
          //           width: 4,
          //           color: Theme.of(context).colorScheme.secondary,
          //         ),
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.all(4),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(50),
          //           child: DecoratedBox(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(50),
          //               image: const DecorationImage(
          //                 fit: BoxFit.cover,
          //                 image: NetworkImage(
          //                   'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
          //                 ), // To BE CHANGED FROM DATABASE
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          //  READYPLAYERME
          const O3D.network(
            src: 'https://models.readyplayer.me/667ea6b3decc99af8e97c067.glb',
          ),
        ],
      ),
    );
  }
}
