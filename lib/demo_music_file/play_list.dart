import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/demo_music_file/controller.dart';
import 'package:music/demo_music_file/fav_full_screen.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';
import 'package:text_scroll/text_scroll.dart';

class play_list extends StatefulWidget {
  const play_list({super.key});

  @override
  State<play_list> createState() => _play_listState();
}

class _play_listState extends State<play_list> {
  @override
  Widget build(BuildContext context) {

    controller c = Get.put(controller());

    return WillPopScope(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: c.get_fav(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done)
          {

            List<FavoritesEntity>  list = snapshot.data as List<FavoritesEntity>;

            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return fav_full_screen();
                },));
              },
              title: Text("Songs",style: TextStyle(color: Colors.white)),
              subtitle: Text("${list.length} songs",style: TextStyle(color: Colors.grey.shade600)),
            );
          }
          else
          {
            return CircularProgressIndicator();
          }
        },
      ),
    ),
        onWillPop: () async{
          exit(0);
        },
    );
  }
}
