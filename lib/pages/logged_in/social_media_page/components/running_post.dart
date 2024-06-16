import 'package:flutter/material.dart';

class RunningPost extends StatefulWidget {
  final String id;
  final String userId;
  final String caption;
  final Object run; // TODO figure out how to settle run object / map object
  final int likes;
  final List<String> comments;

  const RunningPost(
      {super.key,
      required this.id,
      required this.userId,
      required this.caption,
      required this.run,
      required this.likes,
      required this.comments});

  @override
  State<RunningPost> createState() => _RunningPostState();
}

class _RunningPostState extends State<RunningPost> {
  int likes = 0;
  List<String> comments = [];

  @override
  void initState() {
    super.initState();
    likes = widget.likes;
    comments = widget.comments;
  }

  String get id => widget.id;
  String get userId => widget.userId;
  String get caption => widget.caption;
  Object get run => widget.run;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.userId),
            subtitle: Text(widget.caption),
          ),
          Image.network(
              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixlr.com%2Fimage-generator%2F&psig=AOvVaw3La1hOtbr1bK0DXQmiuNbF&ust=1718610129395000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOjm3uTP34YDFQAAAAAdAAAAABAE'),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  setState(() {
                    likes++;
                    print(likes);
                  });
                },
              ),
              Text('$likes likes'),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  // Handle comment button press
                },
              ),
              Text('${comments.length} comments'),
            ],
          ),
          ...comments.map((comment) => ListTile(title: Text(comment))),
        ],
      ),
    );
  }
}
