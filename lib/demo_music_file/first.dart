import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music/demo_music_file/album_list.dart';
import 'package:music/demo_music_file/artist_list.dart';
import 'package:music/demo_music_file/controller.dart';
import 'package:music/demo_music_file/full_screen.dart';
import 'package:music/demo_music_file/play_list.dart';
import 'package:music/demo_music_file/song_list.dart';
import 'package:text_scroll/text_scroll.dart';



void main()
{
    runApp(MaterialApp(
      home: first(),
    ));
}
class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  controller c = Get.put(controller());

  @override
  Widget build(BuildContext context) {
    c.get_check();
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(tabs: [
              Tab(
                child: Text("Songs"),
              ),
              Tab(
                child: Text("Playlist"),
              ),
              Tab(
                child: Text("Artist"),
              ),
              Tab(
                child: Text("Album"),
              )
            ]),
          ),
          backgroundColor: Colors.black,
          bottomNavigationBar: Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade900,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red,
                  trackHeight: 2,
                ),child: Obx(() => Slider(
                  thumbColor: Colors.red,
                  min: 0,
                  max: c.song_list.value.length>0?c.song_list.value[c.cur_ind.value].duration!.toDouble():0,
                  value: c.duration.value, onChanged: (value) {

                },))),
                ListTile(
                  onTap: () {
                    c.get_duration();
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return full_screen();
                    },));
                  },
                    style: ListTileStyle.list,
                    tileColor: Colors.grey.shade800,
                    leading: Container(
                      height: 50,width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.music_note_rounded,color: Colors.white,size: 30),
                    ),
                    // title: Obx(() => c.song_list.value.isNotEmpty?TextScroll("${c.song_list.value[c.cur_ind.value].title}",style: TextStyle(color: Colors.white,),
                    //   intervalSpaces: 50,velocity: Velocity(pixelsPerSecond: Offset(20,20)),
                    // ):TextScroll(""),),
                    title: Obx(() => c.song_list.value.isNotEmpty?TextScroll("${c.song_list.value[c.cur_ind.value].title}",intervalSpaces: 50,velocity: Velocity(pixelsPerSecond: Offset(20,20)),style: TextStyle(color: Colors.white),):Text("")),
                    trailing: Wrap(children: [
                      Obx(() => c.isplay.value?IconButton(
                          onPressed: (){
                            controller.player.pause();
                            c.isplay.value = !c.isplay.value;
                          },
                          icon: Icon(Icons.pause_circle_outline,color: Colors.white,)
                      ):IconButton(
                        onPressed: (){
                          c.isplay.value = !c.isplay.value;
                          controller.player.play(
                              DeviceFileSource(c.song_list.value[c.cur_ind.value].data)
                          );
                        },
                        icon: Icon(Icons.play_circle_outlined,color: Colors.white,),
                      ),
                      ),
                      IconButton(onPressed: (){
                        if(c.cur_ind<c.song_list.length-1)
                        {
                          c.cur_ind++;
                          c.isplay.value=true;
                          controller.player.play(
                              DeviceFileSource(c.song_list.value[c.cur_ind.value].data));
                        }
                        // c.song_list.value[c.cur_ind.value];
                      }, icon: Icon(Icons.skip_next,color: Colors.white,)),
                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return song_list();
                        },));
                      }, icon: Icon(Icons.playlist_play,color: Colors.white,)),
                    ],)
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            song_list(),
            play_list(),
            artist_list(),
            album(),
          ]),
        )
    );
  }
}
