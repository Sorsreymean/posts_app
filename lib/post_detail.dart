import 'dart:convert';

import 'package:post_app/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/posts.dart';
class PostDetail extends StatefulWidget {
  const PostDetail({super.key,required this.post});
  final Post post;
  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List<Posts> post_detail = [];
  @override
  void initState() {
        var url = Uri.parse('https://jsonplaceholder.typicode.com/posts/${widget.post.id}/comments');
        http
        .get(url)
        .then((Response) {
          if (Response.statusCode == 200) {
            dynamic data = jsonDecode(Response.body); //to convert data to dart code
            setState(() {
              for(Map json in data) {
                var posts_detail = Posts(
                  json['id'],
                  json['name'],
                  json['email'],
                  json['body'],
                );
                post_detail.add(posts_detail);
              }
            });
          } else {
            throw Exception('Data cannot be loaded!');
          }
        });
        
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.post.title),
        ),
        body: SizedBox(
        child: Column(
          children: [ 
            Container(
              padding:EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                widget.post.body,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  
                ),
              ), 
            ),
            Container(
              height: 500,
              child: ListView.separated(
                itemBuilder: (context, i)=> ListTile(
                title: Text('${post_detail[i].name} '),
                subtitle: Text(post_detail[i].email),
                 leading: const Icon(Icons.message),
              ), 
              separatorBuilder: (context, index)=> const Divider(color: Colors.grey,), 
                itemCount: post_detail.length,
              ),
            )
            ], 
          ),
      ),
      
    );
  }
  
}