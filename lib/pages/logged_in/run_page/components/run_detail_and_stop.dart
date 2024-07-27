import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:runningapp/models/user.dart' as user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/run_page/components/ratings_page.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/google_maps_container.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:runningapp/pages/logged_in/run_page/paused_page/paused_page.dart';
import 'package:runningapp/models/progress_model.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_pages/running_post_creation_page.dart';
import 'package:runningapp/providers.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RunDetailsAndStop extends ConsumerStatefulWidget {
  final LocationService locationService;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const RunDetailsAndStop(
    this.repository, {
    super.key,
    required this.paddingValue,
    required StopWatchTimer stopWatchTimer,
    required this.context,
    required this.mapContainer,
    required this.auth,
    this.activeStory,
    this.questProgress,
    this.storyRun,
    required this.locationService,
    required this.firestore,
  }) : _stopWatchTimer = stopWatchTimer;

  final double paddingValue;
  final StopWatchTimer _stopWatchTimer;
  final GoogleMapsContainer mapContainer;
  final BuildContext context;
  final String? activeStory;
  final QuestProgressModel? questProgress;
  final bool? storyRun;
  final Repository repository;
  @override
  ConsumerState<RunDetailsAndStop> createState() => _RunDetailsAndStopState();
}

class _RunDetailsAndStopState extends ConsumerState<RunDetailsAndStop> {
  bool savingRun = false;
  bool updateDifficulty = false;

  @override
  void initState() {
    super.initState();
    _checkAndUpdateDifficulty();
  }

  Future<void> _checkAndUpdateDifficulty() async {
    try {
      // Fetch the user model
      user.UserModel model =
          await widget.repository.getUserProfile(widget.auth.currentUser!.uid);
      // every 3 runs prompt user to revamp their plan (rn its turned off)
      if (model.activePlan && model.totalRuns % 3 == 0) {
        setState(() {
          updateDifficulty = true;
        });
      }
    } catch (e) {
      // Handle errors or exceptions
      debugPrint("Error fetching user model: $e");
    }
  }

  Future<void> _checkTrainingPlanAndNavigate(
      String downloadUrl, double distance, int time) async {
    final userId = widget.auth.currentUser?.uid;
    if (userId == null) return;

    final userDoc = widget.firestore.collection('users').doc(userId);
    final trainingPlanSnapshot =
        await userDoc.collection('trainingPlans').get();

    if (trainingPlanSnapshot.docs.isNotEmpty) {
      final trainingPlan = trainingPlanSnapshot.docs.first;
      final trainingPlanRef = trainingPlan.data();
      final runningPlan = trainingPlan['running_plan'] as Map<String, dynamic>;

      final today = DateTime.now();
      final formattedToday = DateFormat('EEEE, d MMMM').format(today);

      for (var week in runningPlan['weeks']) {
        final dailySchedule = week['daily_schedule'] as List<dynamic>;
        for (var day in dailySchedule) {
          debugPrint("Checking day: ${day['day_of_week']}");
          if (day['day_of_week'] == formattedToday &&
              day['run_type'] != 'Rest day') {
            final isCompleted = day['completed'] ?? false;

            if (!isCompleted) {
              debugPrint(
                  "Found today's run in the training plan. Today is $formattedToday, and the run day is ${day['day_of_week']}");

              // Update the completed flag to true
              day['completed'] = true;

              // Update the Firestore document
              await userDoc
                  .collection('trainingPlans')
                  .doc(trainingPlan.id)
                  .update({
                'running_plan': runningPlan,
              });

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RatingPage(
                    widget.repository,
                    updateDifficulty: updateDifficulty,
                    downloadUrl: downloadUrl,
                    runDistance: distance,
                    runTime: time,
                    runPace: (time / 60000) / distance,
                    auth: FirebaseAuth.instance,
                  ),
                ),
              );
              return;
            }
          }
        }
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RunningPostCreationPage(
          repository: widget.repository,
          photoUrl: downloadUrl,
          runDistance: distance,
          runTime: time,
          runPace: (time / 60000) / distance,
          auth: FirebaseAuth.instance,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isHidden = ref.watch(runDetailsProvider);
    return savingRun
        ? Container(
            height: 200,
            width: 200,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Saving Run..."),
                ],
              ),
            ),
          )
        : isHidden
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  key: const Key("showRunDetailsButton"),
                  onPressed: () {
                    ref.read(runDetailsProvider.notifier).showHideRunDetails();
                  },
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              )
            : Animate(
                effects: [
                  SlideEffect(
                      duration: 200.ms,
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0)),
                ],
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.paddingValue,
                    vertical: widget.paddingValue / 2,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        (widget.paddingValue * 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    ////////////////////////////////////////
                    // DISPLAY DISTANCE TIME AND PACE
                    ////////////////////////////////////////
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ////////////////////
                        // Display time
                        ////////////////////
                        TimeDisplayWidget(
                          stopWatchTimer: widget._stopWatchTimer,
                        ),
                        ////////////////////

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // DISPLAY DISTANCE
                            ////////////////////
                            Column(
                              children: [
                                Text(
                                  'Distance',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 15,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.locationService.distanceTravelled
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        " km",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 80,
                              child: VerticalDivider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(100),
                                thickness: 2,
                              ),
                            ),
                            // Display pace
                            PaceDisplayWidget(
                              stopWatchTimer: widget._stopWatchTimer,
                              locationService: widget.locationService,
                            ),
                          ],
                        ),
                        ///////////////////////////////////
                        // STOP RUN BUTTON AND HIDE BUTTON
                        ///////////////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ////////////////////
                            // STOP BUTTON
                            ////////////////////
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          widget.paddingValue / 4),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  bool save = true;
                                  // stop timer
                                  widget._stopWatchTimer.onStopTimer();

                                  // get the time in Milliseconds
                                  final int time =
                                      widget._stopWatchTimer.rawTime.value;

                                  // get distance travelled in KM
                                  final double distance =
                                      widget.locationService.distanceTravelled;

                                  // if travelled less than 20 metres, ask user if sure they want to save run
                                  if (distance < 0.02) {
                                    if (distance == 0) {
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "You have not moved!"),
                                            content: const Text(
                                                "You have not moved at all! You cannot save this run."),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  save = false;
                                                },
                                                child: const Text("Ok"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Are you sure?"),
                                            content: const Text(
                                                "You have only moved 20 metres.\nAre you sure you want to save this run?"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  save = true;
                                                },
                                                child: const Text("Yes"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  save = false;
                                                },
                                                child: const Text("No"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }

                                  if (save) {
                                    setState(() => savingRun = true);
                                    // ask user for name and description of run
                                    String name = "";
                                    String description = "";
                                    await showDialog(
                                      context: mounted ? context : context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Save Run",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                onChanged: (value) {
                                                  name = value;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Run name",
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                onChanged: (value) {
                                                  description = value;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Description",
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    String downloadUrl = await saveRun(
                                      time,
                                      distance,
                                      name,
                                      description,
                                      ref,
                                    );
                                    setState(() => savingRun = false);
                                    stopServices(ref);
                                    _checkTrainingPlanAndNavigate(
                                        downloadUrl, distance, time);
                                    Navigator.pushReplacement(
                                      // TODO IF ERROR THROWN ITS PROBABLY THIS
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RunningPostCreationPage(
                                          repository: widget.repository,
                                          photoUrl: downloadUrl,
                                          runDistance: distance,
                                          runTime: time,
                                          runPace: (time / 60000) / distance,
                                          auth: FirebaseAuth.instance,
                                        ),
                                      ),
                                    );
                                  } else {
                                    debugPrint(
                                        "run detail and stop: Run not saved");
                                    stopServices(ref);
                                  }
                                },
                                key: const Key("stopRunButton"),
                                child: const Icon(Icons.stop),
                              ),
                            ),

                            // PAUSE BUTTON
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          widget.paddingValue / 4),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  // Pause Stopwatch
                                  widget._stopWatchTimer.onStopTimer();
                                  // Pause Location Tracking
                                  LocationService.pauseLocationTracking();
                                  // Show a new page of current stats
                                  showModalBottomSheet(
                                    clipBehavior: Clip.antiAlias,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PausedPage(
                                        stopWatchTimer: widget._stopWatchTimer,
                                        locationService: widget.locationService,
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.pause),
                              ),
                            ),

                            // HIDE BUTTON
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          widget.paddingValue / 4),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  ref
                                      .read(runDetailsProvider.notifier)
                                      .showHideRunDetails();
                                },
                                child: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  void stopServices(WidgetRef ref) {
    // stop location tracking and reset dist
    LocationService.reset();
    // reset timer
    widget._stopWatchTimer.onResetTimer();
    // set boolean to false
    ref.read(timerProvider.notifier).startStopTimer();

    MapLineDrawer.clear();
  }

  void updateStats(double distance, int time) {
    widget.repository.incrementRuns();
    widget.repository.incrementTotalDistanceRan(distance);
    widget.repository.incrementTotalTimeRan(time);
    double totalPoints = distance / (time / 60000) * 10;
    widget.repository.addPoints(totalPoints.toInt());
  }

  Future<String> saveRun(
    int time,
    double distance,
    String name,
    String description,
    WidgetRef ref,
  ) async {
    debugPrint("run detail and stop: Run saved");
    // get pace of run
    final double pace;
    pace = (time / 60000) / distance;

    // show completed run details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            "Run Completed!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Time: ${StopWatchTimer.getDisplayTime(time, hours: false, milliSecond: false)}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Distance: ${distance.toStringAsFixed(2)} km",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Pace: ${pace.floor()} min ${((pace - pace.floor()) * 60).floor()} s per km",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              // Please wait for save to complete!
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Please wait for the run to save...",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Close",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );

    // get runs done
    final String username1 =
        await widget.repository.fetchUsername(widget.auth.currentUser!.uid);
    final int runsDone = await widget.repository.getRunsDone();

    // stop tracking
    LocationService.stopListeningToLocationChanges();
    //take screenshot of current run and upload to fb
    final screenshot = await widget.mapContainer
        .takeSnapshot(MapLineDrawer.polylineCoordinates);
    if (screenshot != null) {
      final Directory tempDir = await getTemporaryDirectory();

      final path = tempDir.path;
      final imageFile = File('$path/$username1$runsDone.png');
      // Write the screenshot data to the file
      // TODO this seems problematic
      imageFile.writeAsBytes(screenshot);
      // Ensure the file has been created and contains data
      if (await imageFile.exists()) {
        try {
          // Reference to your Firebase Storage location
          var imagesRef = FirebaseStorage.instance
              .ref()
              .child('images/$username1$runsDone.png');

          // Upload the file
          await imagesRef.putFile(imageFile);

          debugPrint('run detail and stop: Screenshot uploaded successfully');
        } catch (e) {
          debugPrint('Error uploading screenshot: $e');
        }
      } else {
        debugPrint('Failed to save screenshot to file.');
      }
    }
    final downloadUrl = await FirebaseStorage.instance
        .ref('images/$username1$runsDone.png')
        .getDownloadURL();
    debugPrint("after download url");
    // add run to database
    widget.repository.addRun(
      "runs",
      Run(
        id: "",
        name: name,
        description: description,
        distance: distance.toStringAsFixed(2),
        time: StopWatchTimer.getDisplayTime(time, hours: false),
        date: DateTime.now().toString(),
        polylinePoints: MapLineDrawer.polylineCoordinates,
        imageUrl: downloadUrl,
        pace: pace,
      ),
    );
    debugPrint("after add run");
    //update stats
    updateStats(distance, time);

    // update quest progress
    if (widget.storyRun != null && widget.storyRun == true) {
      widget.repository.updateQuestProgress(distance, time,
          widget.questProgress!.currentQuest, widget.activeStory!, context);
    }
    // update and display achievements
    debugPrint("before update user achievements");
    List<String> newAchievements =
        await widget.repository.updateUserAchievements(distance, time);
    if (newAchievements.isNotEmpty) {
      // Show dialog with the list of new achievements
      showDialog(
        context: widget.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("New achievements earned:"),
            content: SingleChildScrollView(
              child: ListBody(
                children: newAchievements
                    .map((achievement) => Text(achievement))
                    .toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Yay!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return downloadUrl;
  }
}

class TimeDisplayWidget extends StatelessWidget {
  const TimeDisplayWidget({
    super.key,
    required StopWatchTimer stopWatchTimer,
  }) : _stopWatchTimer = stopWatchTimer;

  final StopWatchTimer _stopWatchTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Column(
            children: [
              /// Display stop watch time
              StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime = StopWatchTimer.getDisplayTime(
                      value,
                      hours: false,
                      milliSecond: false,
                    );
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: TextStyle(
                              fontSize: 70,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

class PaceDisplayWidget extends StatelessWidget {
  final LocationService locationService;

  const PaceDisplayWidget({
    super.key,
    required StopWatchTimer stopWatchTimer,
    required this.locationService,
  }) : _stopWatchTimer = stopWatchTimer;

  final StopWatchTimer _stopWatchTimer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Pace',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.bold,
          ),
        ),
        StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            initialData: _stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              // debugPrint((snap.data! / 1000).toString());
              final value = snap.data!;
              final currentTime = value;
              return PaceWidget(
                locationService: locationService,
                currentTime: currentTime,
              );
            }),
      ],
    );
  }
}

class PaceWidget extends StatelessWidget {
  final LocationService locationService;

  const PaceWidget({
    super.key,
    required this.currentTime,
    required this.locationService,
  });

  final int currentTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                locationService.distanceTravelled == 0
                    ? '0'
                    // minutes
                    : "${((currentTime / 60000) / locationService.distanceTravelled).toStringAsFixed(0)}:",
                style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                locationService.distanceTravelled == 0
                    ? '0'
                    // minutes
                    : ((((currentTime / 60000) /
                                    locationService.distanceTravelled) -
                                ((currentTime / 60000) /
                                        locationService.distanceTravelled)
                                    .floor()) *
                            60)
                        .toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                " min/km",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
