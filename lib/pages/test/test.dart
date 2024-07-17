import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> createPost() async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie':
        'AWSALB=SOYzQusd+p5IHliR6u3K7G7fVT/BLITdFN8FECw9m4VbSp+7SGMVkAZJkAIkl/n7iq8LA5/mEH7D5eNhgs89q51Rcl09M29PQSnYlRr51X6OESTpk3pDJm4RM9Uu; AWSALBCORS=SOYzQusd+p5IHliR6u3K7G7fVT/BLITdFN8FECw9m4VbSp+7SGMVkAZJkAIkl/n7iq8LA5/mEH7D5eNhgs89q51Rcl09M29PQSnYlRr51X6OESTpk3pDJm4RM9Uu'
  };
  var request = http.Request('POST',
      Uri.parse('https://goorunners-m53w30.readyplayer.me/api/auth/login'));
  request.body = json.encode({
    "data": {"code": "HXWRC2Y4"}
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
