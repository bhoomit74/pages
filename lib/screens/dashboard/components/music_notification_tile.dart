import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicNotificationTile extends StatefulWidget {
  const MusicNotificationTile({Key? key}) : super(key: key);

  @override
  State<MusicNotificationTile> createState() => _MusicNotificationTileState();
}

class _MusicNotificationTileState extends State<MusicNotificationTile> {
  double sliderValue = 10;
  bool isPause = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                      "https://i1.sndcdn.com/avatars-V0jZqMMmveX1dzS0-JcV0jw-t500x500.jpg"),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Song Name",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Arijit singh",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white38,
                          fontWeight: FontWeight.w200,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: const [
                        Divider(
                          thickness: 2,
                          color: Colors.white24,
                        ),
                        SizedBox(
                          width: 40,
                          child: Divider(
                            thickness: 2,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          CupertinoIcons.backward_end_fill,
                          color: Colors.white,
                        ),
                        //Icon(CupertinoIcons.pause_fill),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPause = !isPause;
                            });
                          },
                          child: Icon(
                            isPause
                                ? CupertinoIcons.play_arrow_solid
                                : CupertinoIcons.pause_fill,
                            color: Colors.white,
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.forward_end_fill,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
