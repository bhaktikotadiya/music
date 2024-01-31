import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/demo_music_file/controller.dart';
import 'package:music/demo_music_file/song_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class artist_list extends StatefulWidget {
  const artist_list({super.key});

  @override
  State<artist_list> createState() => _artist_listState();
}

class _artist_listState extends State<artist_list> {
  @override
  Widget build(BuildContext context) {

    controller c=Get.put(controller());

    return WillPopScope(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(future: c.get_artist(),builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done){
          List<ArtistModel>l=snapshot.data as List<ArtistModel>;

          return ListView.builder(
            itemCount: l.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return song_list();
                  },));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.account_circle_rounded,color: Colors.grey.shade900,size: 45),
                ),
                // leading: Container(
                //   height: 60,width: 60,
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade800,
                //     borderRadius: BorderRadius.circular(50),
                //   ),
                //   child: Icon(Icons.account_circle_rounded,color: Colors.white,size: 35),
                // ),
                title: Text("${l[index].artist} Artist",style: TextStyle(color: Colors.white)),
                subtitle: Text("${c.song_list.length} songs",style: TextStyle(color: Colors.grey.shade600)),
              );
            },);
        }
        else
        {
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
