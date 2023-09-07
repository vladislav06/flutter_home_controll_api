import 'package:flutter/material.dart';
import 'package:home_controller/api.dart';
import 'package:home_controller/settings.dart';
import 'package:home_controller/settings_screen.dart';
import 'package:http/http.dart' as http;

void main() {
    //await SettingsManager().init();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.1,
                fontSizeDelta: 2.0,
              )),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool stripState = false;
  bool speakersState = false;
  bool projectorState = false;
  bool pcState = false;

  late TextEditingController speakersTime;
  late TextEditingController projectorTime;
  late TextEditingController pcTime;

  bool projectorSync = false;
  bool pcSync = false;

  double stripVal = 0.0;
  double volume = 0.0;
  bool serverState = false;

  @override
  void initState() {
    speakersTime = TextEditingController();
    projectorTime = TextEditingController();
    pcTime = TextEditingController();

    speakersState = Api.getBool(SettingsManager().ip1, 2);
    projectorState = Api.getBool(SettingsManager().ip1, 0);
    pcState = Api.getBool(SettingsManager().ip1, 1);

    _updateServerState();

    super.initState();
  }

  @override
  void dispose() {
    speakersTime.dispose();
    projectorTime.dispose();
    pcTime.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Settings();
                }));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Strip"),
            Row(
              children: [
                Switch(
                    value: stripState,
                    onChanged: (val) {
                      setState(() {
                        stripState = val;
                        //TODO:
                      });
                    }),
                Expanded(
                  child: Slider(
                    value: stripVal,
                    onChanged: (val) {
                      setState(() {
                        stripVal = val;
                        //TODO:
                      });
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            //==================================================
            const Text("Speakers"),
            Row(
              children: [
                Switch(
                  value: speakersState,
                  onChanged: (val) {
                    setState(() {
                      speakersState = val;
                      if (speakersState) {
                        Api.post(Command.time, SettingsManager().ip1, 2);
                      } else {
                        Api.postInt(Command.time, SettingsManager().ip1, 2, 0);
                      }
                    });
                  },
                ),
                const Spacer(),
                const Text("Time:"),
                SizedBox(
                  width: 100,
                  child: TextField(
                      controller: speakersTime,
                      keyboardType: TextInputType.number),
                ),
                IconButton(
                    onPressed: () {
                      Api.postInt(Command.time, SettingsManager().ip1, 2,
                          int.parse(speakersTime.text));
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
            const Divider(),
            //==================================================
            Row(
              children: [
                const Text("Projector"),
                const Spacer(),
                const Text("Sync:"),
                Checkbox(
                  value: projectorSync,
                  onChanged: (val) {
                    setState(() {
                      projectorSync = val ?? false;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: projectorState,
                  onChanged: (val) {
                    setState(() {
                      projectorState = val;
                      if (projectorState) {
                        Api.post(Command.time, SettingsManager().ip1, 0);
                      } else {
                        Api.postInt(Command.time, SettingsManager().ip1, 0, 0);
                      }
                    });
                  },
                ),
                const Spacer(),
                const Text("Time:"),
                SizedBox(
                  width: 100,
                  child: TextField(
                      controller: projectorTime,
                      keyboardType: TextInputType.number),
                ),
                IconButton(
                    onPressed: () {
                      Api.postInt(Command.time, SettingsManager().ip1, 0,
                          int.parse(projectorTime.text));
                      if (projectorSync) {
                        Api.postInt(Command.time, SettingsManager().ip1, 2,
                            int.parse(projectorTime.text));
                      }
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
            const Divider(),
            //==================================================
            Row(
              children: [
                const Text("PC"),
                const Spacer(),
                const Text("Sync:"),
                Checkbox(
                  value: pcSync,
                  onChanged: (val) {
                    setState(() {
                      pcSync = val ?? false;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: pcState,
                  onChanged: (val) {
                    setState(() {
                      pcState = val;
                      if (pcState) {
                        Api.post(Command.time, SettingsManager().ip1, 1);
                      } else {
                        Api.postInt(Command.time, SettingsManager().ip1, 1, 0);
                      }
                    });
                  },
                ),
                const Spacer(),
                const Text("Time:"),
                SizedBox(
                  width: 100,
                  child: TextField(
                      controller: pcTime, keyboardType: TextInputType.number),
                ),
                IconButton(
                    onPressed: () {
                      Api.postInt(Command.time, SettingsManager().ip1, 1,
                          int.parse(pcTime.text));
                      if (pcSync) {
                        Api.postInt(Command.time, SettingsManager().ip1, 2,
                            int.parse(pcTime.text));
                      }
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
            Row(
              children: [
                const Text("Volume"),
                Expanded(
                  child: Slider(
                    value: volume,
                    onChanged: (val) {
                      setState(() {
                        volume = val;
                        //TODO:
                      });
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            //==================================================
            const Text("Server"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        http.get(Uri.http(SettingsManager().ip2.ip, "on"));
                      },
                      child: const Text("ON")),
                  const Spacer(),
                  InkWell(
                    child: Text("State: ${serverState ? "ON" : "OFF"}"),
                    onTap: () => _updateServerState(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateServerState() {
    try {
      http
          .get(Uri.http(SettingsManager().ip2.ip, "get-state"))
          .then((response) {
        setState(() {
          serverState = response.body.contains("on");
        });
      });
    } catch (e) {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => Center(
                child: Material(
                  color: Colors.transparent,
                  child: Text(e.toString()),
                ),
              ));
    }
  }
}
