import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/demo_music_file/first.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main()
async {
  await OnAudioRoom().initRoom(RoomType.FAVORITES);
  runApp(MaterialApp(
    home: page(),
    debugShowCheckedModeBanner: false,
  ));
}
class page extends StatefulWidget {
  const page({super.key});

  @override
  State<page> createState() => _pageState();
}

class _pageState extends State<page> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    permission();

    Future.delayed(Duration(seconds: 7)).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return first();
      },));
    },);
  }

  permission()
  async {
    var status = await Permission.storage.status;
    if (status.isDenied)
    {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.storage,
        ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.red.shade800,Colors.red.shade400,Colors.red.shade200],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Icon(Icons.music_note_outlined,size:60,color: Colors.white,),
          ),
        ),
      // body: AnimateGradient(
      //   primaryBegin: Alignment.topLeft,
      //   primaryEnd: Alignment.bottomLeft,
      //   secondaryBegin: Alignment.bottomLeft,
      //   secondaryEnd: Alignment.topRight,
      //   primaryColors: const [
      //     Colors.pink,
      //     Colors.pinkAccent,
      //     Colors.white,
      //   ],
      //   secondaryColors: const [
      //     Colors.white,
      //     Colors.blueAccent,
      //     Colors.blue,
      //   ],
      //   child: Center(
      //     child: GestureDetector(
      //       onTap: () {
      //         Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //           return const Scaffold();
      //         }));
      //       },
      //       child: AnimatedTextKit(
      //         animatedTexts: [
      //           WavyAnimatedText("MUSIC PLAYER",textStyle: GoogleFonts.acme(fontSize: 40)),
      //           // WavyAnimatedText('Look at the waves'),
      //         ],
      //         isRepeatingAnimation: false,
      //         onTap: () {
      //           print("Tap Event");
      //         },
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
