//TODO RENAME TH IS STUPID FILE NAME

class PostJsonStuff {
  final String id;
  final String userId;
  final String caption;
  final Object run; // TODO figure out how to settle run object / map object
  final int likes;
  final List<String> comments;

  PostJsonStuff({
    required this.id,
    required this.userId,
    required this.caption,
    required this.run,
    required this.likes,
    required this.comments,
  });

  PostJsonStuff.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        caption = json['caption'],
        run = json['run'],
        likes = json['likes'],
        comments = json['comments'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "caption": caption,
      "run": run,
      "likes": likes,
      "comments": comments,
    };
  }
}
