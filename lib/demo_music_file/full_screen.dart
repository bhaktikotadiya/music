import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:music/demo_music_file/controller.dart';
import 'package:music/demo_music_file/song_list.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:text_scroll/text_scroll.dart';

class full_screen extends StatefulWidget {
  const full_screen({super.key});

  @override
  State<full_screen> createState() => _full_screenState();
}

class _full_screenState extends State<full_screen> {
  @override
  Widget build(BuildContext context) {

    double Screen_height=MediaQuery.of(context).size.height;
    double Status_height=MediaQuery.of(context).padding.top;
    double AppBar_height=kToolbarHeight;
    print("Screen_height : $Screen_height");
    print("Status_height : $Status_height");
    print("AppBar_height : $AppBar_height");
    int cnt=0;
    controller c=Get.put(controller());
    c.get_check();

    return Scaffold(

      bottomNavigationBar: AnimatedContainer(
        duration: Duration(seconds: 2),
        child: Container(
          height: Screen_height,
          color: Colors.grey.shade900,
          child: Column(
            children: [
              SizedBox(height: 100,),
              Expanded(flex: 8,
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(40, 30, 40, 40),
                    decoration: BoxDecoration(color: Colors.grey.shade800,borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.music_note,size: 200,color: Colors.grey.shade700,)),
              ),
              // SizedBox(height: 30,),
              Expanded(
                child: SliderTheme(data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red,
                  trackHeight: 2,
                ),child: Obx(() => Slider(
                  thumbColor: Colors.red,
                  min: 0,
                  max: c.song_list.value.length>0?c.song_list.value[c.cur_ind.value].duration!.toDouble():0,
                  value: c.duration.value, onChanged: (value) {

                },))),
              ),
              SizedBox(height: 20),
              Obx(() {
                return TextScroll("${c.song_list.value[c.cur_ind.value].title}",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                  intervalSpaces: 50,velocity: Velocity(pixelsPerSecond: Offset(20,20)),
                );
                // return Text("${c.song_list.value[c.cur_ind.value].title}",maxLines: 1,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),);
              }),            // SizedBox(height: 10,),
              Obx(() {
                return Text("${c.song_list.value[c.cur_ind.value].artist}",style: TextStyle(color: Colors.grey.shade700,fontSize: 15),);
              }),
              SizedBox(height: 50,),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: (){
                      if(c.cur_ind.value>0)
                      {
                        print("previous");
                        c.cur_ind.value--;
                        c.isplay.value=true;
                        controller.player.play(
                            DeviceFileSource(c.song_list.value[c.cur_ind.value].data));
                      }
                    }, icon: Icon(Icons.skip_previous,size: 70,color: Colors.red.shade800,)),
                    Obx(() => c.isplay.value?IconButton(
                        onPressed: (){
                          print("pause");
                          controller.player.pause();
                          c.isplay.value = !c.isplay.value;
                        },
                        icon: Icon(Icons.pause_circle_outline,color: Colors.red.shade800,size: 70)
                    ):IconButton(
                      onPressed: (){
                        print("play");
                        c.isplay.value = !c.isplay.value;
                        controller.player.play(
                            DeviceFileSource(c.song_list.value[c.cur_ind.value].data)
                        );
                      },
                      icon: Icon(Icons.play_circle_outlined,color: Colors.red.shade800,size: 70),
                     ),
                    ),
                    IconButton(onPressed: (){
                      if(c.cur_ind.value<c.song_list.length-1)
                      {
                        print("next");
                        c.cur_ind.value++;
                        c.isplay.value=true;
                        controller.player.play(
                            DeviceFileSource(c.song_list.value[c.cur_ind.value].data));
                      }
                    }, icon: Icon(Icons.skip_next,size: 70,color: Colors.red.shade800,)),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return song_list();
                        },));
                      },icon: Icon(Icons.list,size: 25,color: Colors.white,),
                    ),
                    Obx(() =>
                        c.fav.value?
                        IconButton(onPressed: () async {
                          bool deleteFromResult = await OnAudioRoom().deleteFrom(
                            RoomType.FAVORITES,
                            c.song_list.value[c.cur_ind.value].id,
                            //playlistKey,
                          );
                          c.get_check();
                        },icon: Icon(Icons.favorite,size: 25,color: Colors.white,),):
                        IconButton(onPressed: () async {
                          int? addToResult = await OnAudioRoom().addTo(
                            RoomType.FAVORITES,
                            c.song_list.value[c.cur_ind.value].getMap.toFavoritesEntity(),
                          );
                          c.get_check();
                        },icon: Icon(Icons.favorite_border,size: 25,color: Colors.white,),),
                    ),
                    IconButton(onPressed: () {
                      print("repeat");
                        c.get_repeat();
                        cnt++;
                      },icon: Icon(Icons.repeat,size: 25,color: Colors.white,),
                    ),
                    IconButton(onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("${cnt} time play this song"),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("OK"))
                            ],
                          );
                        },);
                      },icon: Icon(Icons.more_horiz,size: 25,color: Colors.white,),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
      // body: Container(
      //   height: Screen_height,
      //   color: Colors.grey.shade900,
      //   child: Column(
      //     children: [
      //       SizedBox(height: 100,),
      //       Expanded(flex: 8,
      //         child: Container(
      //             height: double.infinity,
      //             width: double.infinity,
      //             margin: EdgeInsets.fromLTRB(60, 30, 60, 20),
      //             decoration: BoxDecoration(color: Colors.grey.shade800,borderRadius: BorderRadius.circular(20)),
      //             child: Icon(Icons.music_note,size: 200,color: Colors.grey.shade700,)),
      //       ),
      //       Expanded(
      //         child: SliderTheme(data: SliderTheme.of(context).copyWith(
      //           activeTrackColor: Colors.red,
      //           trackHeight: 2,
      //         ),child: Obx(() => Slider(
      //           thumbColor: Colors.red,
      //           min: 0,
      //           max: c.song_list.value.length>0?c.song_list.value[c.cur_ind.value].duration!.toDouble():0,
      //           value: c.duration.value, onChanged: (value) {
      //
      //         },))),
      //       ),
      //       SizedBox(height: 20),
      //       Obx(() {
      //         return Text("${c.song_list.value[c.cur_ind.value].title}",maxLines: 1,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),);
      //       }),            // SizedBox(height: 10,),
      //       Obx(() {
      //         return Text("${c.song_list.value[c.cur_ind.value].artist}",style: TextStyle(color: Colors.grey.shade700,fontSize: 15),);
      //       }),
      //       SizedBox(height: 50,),
      //       Expanded(
      //         child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             IconButton(onPressed: (){
      //               if(c.cur_ind.value>0)
      //               {
      //                 print("previous");
      //                 c.cur_ind.value--;
      //                 c.isplay.value=true;
      //                 controller.player.play(
      //                     DeviceFileSource(c.song_list.value[c.cur_ind.value].data));
      //               }
      //             }, icon: Icon(Icons.skip_previous,size: 70,color: Colors.red.shade800,)),
      //             Obx(() => c.isplay.value?IconButton(
      //                 onPressed: (){
      //                   print("pause");
      //                   controller.player.pause();
      //                   c.isplay.value = !c.isplay.value;
      //                 },
      //                 icon: Icon(Icons.pause_circle_outline,color: Colors.red.shade800,size: 70)
      //             ):IconButton(
      //               onPressed: (){
      //                 print("play");
      //                 c.isplay.value = !c.isplay.value;
      //                 controller.player.play(
      //                     DeviceFileSource(c.song_list.value[c.cur_ind.value].data)
      //                 );
      //               },
      //               icon: Icon(Icons.play_circle_outlined,color: Colors.red.shade800,size: 70),
      //               ),
      //             ),
      //             IconButton(onPressed: (){
      //               if(c.cur_ind.value<c.song_list.length-1)
      //               {
      //                 print("next");
      //                 c.cur_ind.value++;
      //                 c.isplay.value=true;
      //                 controller.player.play(
      //                     DeviceFileSource(c.song_list.value[c.cur_ind.value].data));
      //               }
      //             }, icon: Icon(Icons.skip_next,size: 70,color: Colors.red.shade800,)),
      //           ],
      //         ),
      //       ),
      //       SizedBox(
      //         height: 80,
      //       ),
      //       Expanded(
      //         child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Icon(Icons.list,size: 25,color: Colors.white,),
      //             Icon(Icons.favorite_border,size: 25,color: Colors.white,),
      //             Icon(Icons.repeat,size: 25,color: Colors.white,),
      //             Icon(Icons.more_horiz,size: 25,color: Colors.white,),
      //           ],
      //         ),
      //       )
      //
      //     ],
      //   ),
      // ),
    );
  }
}
