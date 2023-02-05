import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/post.dart';
import 'package:post_app/post_detail.dart';

class _UserListState extends State<UserList> {
  List<Post> posts = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Posts'),
      actions: [
          IconButton(onPressed: () {
            loadData();
          }, icon: const Icon(Icons.refresh)),
        ],
      ),
      
      body: ListView.separated(
        itemBuilder: (context, index)=> ListTile(
          title: Text('${posts[index].title} ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          subtitle: Text('${posts[index].body} '),
          leading: const Icon(Icons.text_snippet),
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => PostDetail(post: posts[index])
              )
            );
          },
        ), 
        separatorBuilder: (context, index)=> const Divider(color: Colors.grey,), 
        itemCount: posts.length,
        ),
    );
  }
  void loadData({String search = ''}) {
    //default url to get all data
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    //search data if the search argment presents
    http
        .get(url)
        .then((Response) {
      if (Response.statusCode == 200) {
        dynamic data = jsonDecode(Response.body); //to convert data to dart code
        setState(() {
          for(Map json in data) {
            var post = Post(
              json['id'],
              json['title'],
              json['body'],
            );
            posts.add(post);
          }
        });
      } else {
        throw Exception('Data cannot be loaded!');
      }
    });
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}