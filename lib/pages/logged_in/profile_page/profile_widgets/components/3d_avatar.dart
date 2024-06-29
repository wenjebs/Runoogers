import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/rpm_api_service.dart';
import 'package:runningapp/pages/logged_in/profile_page/webtest.dart';

class RPMAvatar extends StatefulWidget {
  const RPMAvatar({super.key});

  @override
  State<RPMAvatar> createState() => _RPMAvatarState();
}

class _RPMAvatarState extends State<RPMAvatar> {
  final RpmApiService rpmApiService =
      RpmApiService(baseUrl: 'https://goorunners.readyplayer.me');

  String? avatarId;
  String? avatarUrl;
  bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   createAvatar();
  // }

  // Future<void> createAvatar() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     await rpmApiService.createAnonUser();
  //     final templates = await rpmApiService.fetchTemplates();
  //     final draftAvatar =
  //         await rpmApiService.createDraftAvatar(templates.first['id']);
  //     avatarId = draftAvatar['id'];
  //     await rpmApiService.saveAvatar(avatarId!);
  //     final response = await rpmApiService.fetchAvatar(avatarId!);
  //     setState(() {
  //       avatarUrl = response.request?.url.toString();
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const WebTest())),
    );
  }
}
