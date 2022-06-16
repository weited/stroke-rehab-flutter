import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/widgets/alert_dialog.dart';
import 'package:stroke_rehab/widgets/display_detail_card.dart';
import 'package:stroke_rehab/widgets/large_action_button.dart';

class HistoryDetails extends StatefulWidget {
  final String id;
  final Function keepFilter;

  HistoryDetails({Key? key, required this.id, required this.keepFilter}) : super(key: key);

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  late ExerciseModel exerciseModel;
  late Exercise exercise;
  late String imgPath;

  @override
  void initState() {
    super.initState();
    exerciseModel = Provider.of<ExerciseModel>(context, listen: false);
    exercise = exerciseModel.get(widget.id);
    imgPath = exercise.imgPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Summary',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetailCard(exercise: exercise),
              ),),
          Text('Button List', style: Theme.of(context).textTheme.titleMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Time',
                style: TextStyle(fontSize: 14),
              ),
              const Text(
                'Button',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView.builder(
                      itemBuilder: (_, index) {
                        var item = exercise.btnPressed![index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(item.keys.toString()),
                              Text(item.values.toString()),
                            ],
                          ),
                        );
                      },
                      itemCount: exercise.btnPressed?.length),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: imgPath.isEmpty
                  ? const Text('No picture')
                  : ImageDisplay(
                      imgPath: imgPath,
                    ),
            ),
          ),
          SizedBox(
            height: kBottomContainerHeight,
            child: Row(
              children: [
                Expanded(
                  child: LargeSelectionButton(
                    buttonTitle: 'Share',
                    onPressed: () async {
                      await Share.share(exercise.shareRecord());
                    },
                  ),
                ),
                const SizedBox(
                  width: 1.5,
                ),
                Expanded(
                  child: LargeSelectionButton(
                    buttonTitle: 'Delete',
                    onPressed: () async {
                      bool exit = false;
                      await showDialog(
                          context: context,
                          builder: (_) => CustomAlertDialog(
                                titleText: 'delete',
                                onConfirmAction: () async {
                                  await exerciseModel.delete(widget.id);
                                  exit = true;
                                  Navigator.of(context).pop();
                                  widget.keepFilter();
                                },
                                onCancelAction: () {
                                  exit = false;
                                  Navigator.of(context).pop();
                                },
                              ));
                      exit ? Navigator.of(context).pop() : null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  final String imgPath;

  ImageDisplay({Key? key, required this.imgPath}) : super(key: key);

  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: storageRef.child(imgPath).getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return const SizedBox(
              height: 150, width: 150, child: CircularProgressIndicator());
        }
        var downloadURL = snapshot.data!;
        return SizedBox(height: 150, child: Image.network(downloadURL));
      },
    );
  }
}
