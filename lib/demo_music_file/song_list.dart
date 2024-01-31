import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/demo_music_file/controller.dart';
import 'package:music/demo_music_file/full_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class song_list extends StatefulWidget {
  const song_list({super.key});

  @override
  State<song_list> createState() => _song_listState();
}

class _song_listState extends State<song_list> {
  @override
  Widget build(BuildContext context) {

    controller c=Get.put(controller());

    return WillPopScope(
        child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
        future: c.get_song(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done)
          {
            List<SongModel> l=snapshot.data as List<SongModel>;
            print("l = ${l}");
            return Card(
              child: ListView.builder(
                itemCount: l.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      c.get_check();
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return full_screen();
                      },));
                      // c.get_check();
                      c.get_duration();
                      c.isplay.value=true;
                      if(c.cur_ind.value==index)
                      {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //   return full_screen();
                        // },));
                      }
                      else
                      {
                        c.cur_ind.value=index;
                        controller.player.play(
                            DeviceFileSource(c.song_list.value[c.cur_ind.value].data));
                      }
                    },
                    tileColor: Colors.black,
                    title: Obx(() => c.cur_ind==index && c.isplay.value?Text("${l[index].title}",maxLines: 1,style: TextStyle(color: Colors.red),):Text("${l[index].title}",style: TextStyle(color: Colors.white),maxLines: 1,)),
                    subtitle: Obx(() => c.cur_ind==index && c.isplay.value?Text("${l[index].artist} Artist - ${l[index].album} Album",maxLines: 1,style: TextStyle(color: Colors.red)):Text("${l[index].artist} Artist - ${l[index].album} Album",maxLines: 1,style: TextStyle(color: Colors.white))),
                    trailing: Wrap(children: [
                      Obx(() => c.cur_ind==index && c.isplay.value?
                      Image.network("https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",height: 40,width: 40,):
                      Text(""))
                    ],),
                  );
                },
              ),
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
        },);
  }
}
