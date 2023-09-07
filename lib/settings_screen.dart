import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_controller/settings.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          SettingsEntry(
              name: "IP1",
              value: SettingsManager().ip1.ip,
              onSave: (val) {
                SettingsManager().ip1.ip = val;
                SettingsManager().save();
              }),
          SettingsEntry(
              name: "IP2",
              value: SettingsManager().ip2.ip,
              onSave: (val) {
                SettingsManager().ip2.ip = val;
                SettingsManager().save();
              }),
        ],
      ),
    );
  }
}

class SettingsEntry extends StatefulWidget {
  const SettingsEntry({
    super.key,
    required this.name,
    required this.value,
    required this.onSave,
  });

  final String name;
  final String value;
  final Function(String) onSave;

  @override
  State<StatefulWidget> createState() {
    return _SettingsEntry();
  }
}

class _SettingsEntry extends State<SettingsEntry> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    controller.text = widget.value;

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name),
        TextField(
          controller: controller,
          onEditingComplete: () {
            widget.onSave(controller.text);
            FocusManager.instance.primaryFocus?.unfocus();
          },
        )
      ],
    );
  }
}
