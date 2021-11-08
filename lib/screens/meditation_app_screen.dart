import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditations_app/models/item_model.dart';

class MeditationAppScreen extends StatefulWidget {
  const MeditationAppScreen({Key? key}) : super(key: key);

  @override
  _MeditationAppScreenState createState() => _MeditationAppScreenState();
}

class _MeditationAppScreenState extends State<MeditationAppScreen> {
  final List<Item> items = [
    Item(
      name: "Forest",
      audioPath: 'assets/audios/forest.mp3',
      imagePath: 'assets/images/forest.jpeg',
    ),
    Item(
      name: "Night",
      audioPath: 'assets/audios/night.mp3',
      imagePath: 'assets/images/night.jpeg',
    ),
    Item(
      name: "Ocean",
      audioPath: 'assets/audios/ocean.mp3',
      imagePath: 'assets/images/ocean.jpeg',
    ),
    Item(
      name: "Waterfall",
      audioPath: 'assets/audios/waterfall.mp3',
      imagePath: 'assets/images/waterfall.jpeg',
    ),
    Item(
      name: "Wind",
      audioPath: 'assets/audios/wind.mp3',
      imagePath: 'assets/images/wind.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SoundWidget(item: items[index], index: index),
            );
          },
        ),
      ),
    );
  }
}

class SoundWidget extends StatefulWidget {
  final int index;
  final Item item;

  const SoundWidget({Key? key, required this.item, required this.index}) : super(key: key);

  @override
  _SoundWidgetState createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  final AudioPlayer audioPlayer = AudioPlayer();

  int? playingIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(widget.item.imagePath),
        ),
      ),
      child: ListTile(
        title: Text(widget.item.name),
        leading: IconButton(
          icon: (playingIndex == widget.index)
              ? const FaIcon(FontAwesomeIcons.stop)
              : const FaIcon(FontAwesomeIcons.play),
          onPressed: () async {
            if (playingIndex == widget.index) {
              setState(() {
                playingIndex = null;
              });
              audioPlayer.stop();
            } else {
              try {
                await audioPlayer.setAsset(widget.item.audioPath).catchError((onError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red.withOpacity(0.5),
                      content: Text("Oops, an error has occurred..."),
                    ),
                  );
                });
                audioPlayer.play();
                setState(() {
                  playingIndex = widget.index;
                });
              } catch (error) {
                print(error);
              }
            }
          },
        ),
      ),
    );
  }
}
