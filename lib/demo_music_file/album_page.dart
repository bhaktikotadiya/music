import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/demo_music_file/controller.dart';
import 'package:music/demo_music_file/full_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class album_page extends StatelessWidget {
  AlbumModel l;
  album_page(this.l);

  // const album_page({super.key});

  @override
  Widget build(BuildContext context) {

    controller c = Get.put(controller());
    int index_val=0;
    c.get_check();
    // List <bool> temp=List.filled(l.id, false);

    return Scaffold(
      appBar: AppBar(
        title: Text("${l.album}",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
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
                title: Obx(() => c.song_list.value.isNotEmpty?TextScroll("${c.song_list.value[c.cur_ind.value].title}",style: TextStyle(color: Colors.white),intervalSpaces: 50,velocity: Velocity(pixelsPerSecond: Offset(20,20))):Text("")),
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

                  }, icon: Icon(Icons.playlist_play,color: Colors.white,)),
                ],)
            ),
          ],
        ),
      ),
      body: FutureBuilder(
          future: c.getallsong(l.id),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.done)
            {
                List<SongModel> l = snapshot.data as List<SongModel>;
                // List <bool> temp=List.filled(l.length, false);
                return ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return full_screen();
                        },));
                        c.isplay.value=true;
                        print("album index= ${index}");
                        // temp[index] = true;
                        for(int i=0;i<c.song_list.value.length;i++)
                          {
                              if(c.song_list.value[i].id==l[index].id)
                              {
                                    if(i==c.cur_ind.value)
                                    {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        //   return full_screen();
                                        // },));
                                    }
                                    else
                                    {
                                      c.cur_ind.value=i;
                                      index_val = i ;
                                      print("i=${i}");
                                      print("index_val=${index_val}");
                                      print("c.cur_ind.value=${c.cur_ind.value}");
                                      print("l[index].id=${l[index].id}");
                                      print("c.song_list.value[i].id=${c.song_list.value[c.cur_ind.value]}");
                                      controller.player.play(DeviceFileSource(c.song_list.value[c.cur_ind.value].data));
                                    }
                              }
                          }

                      },
                      title: Text("${l[index].title}",style: TextStyle(color: Colors.white),maxLines: 1,),
                      subtitle: Text("${l[index].artist} Artist - ${l[index].album} Album",style: TextStyle(color: Colors.grey.shade600),),
                      // trailing: Wrap(children: [
                      //   Obx(() => c.cur_ind==index && c.isplay.value?
                      //   Image.network("https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",height: 40,width: 40,):
                      //   Text(""))
                      // ],),
                      // title: Obx(() =>
                      //    c.cur_ind.value==index && c.isplay.value?Text("${l[index].title}",maxLines: 1,style: TextStyle(color: Colors.red),):
                      //    Text("${l[index].title}",maxLines: 1,style: TextStyle(color: Colors.white),),
                      // ),
                      // subtitle: Obx(() =>
                      //   c.cur_ind.value==index && c.isplay.value?Text("${l[index].artist} Artist - ${l[index].album} Album",style: TextStyle(color: Colors.red),):
                      //   Text("${l[index].artist} Artist - ${l[index].album} Album",style: TextStyle(color: Colors.grey.shade600),),
                      // ),
                    );
                  },
                );
            }
            else
            {
                return CircularProgressIndicator();
            }
          },
      ),
    );
  }
}
