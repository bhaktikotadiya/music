import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/demo_music_file/album_page.dart';
import 'package:music/demo_music_file/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class album extends StatefulWidget {
  const album({super.key});

  @override
  State<album> createState() => _albumState();
}

class _albumState extends State<album> {
  @override
  Widget build(BuildContext context) {

    controller c=Get.put(controller());

    return WillPopScope(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(future: c.get_album(),builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done){

          List<AlbumModel>l=snapshot.data as List<AlbumModel>;
          return ListView.builder(
            itemCount: l.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return album_page(l[index]);
                  },));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.folder_open_outlined,color: Colors.grey.shade800,size: 25),
                ),
                // leading: Container(
                //   height: 60,width: 60,
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade800,
                //     borderRadius: BorderRadius.circular(5),
                //   ),
                //   child: Icon(Icons.folder_open_outlined,color: Colors.white,size: 30),
                // ),
                title: Text("${l[index].album}",style: TextStyle(color: Colors.white)),
                subtitle: Text("${l[index].numOfSongs} songs",style: TextStyle(color: Colors.grey.shade600)),
              );
            },);
        }
        else{
          return CircularProgressIndicator();
        }
      },),
    ),
        onWillPop: () async{
          exit(0);
        },
    );
  }
}
