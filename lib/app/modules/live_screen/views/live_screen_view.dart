import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/live_stream_page.dart';
import '../../../../config/common_textfield.dart';

import '../controllers/live_screen_controller.dart';
class LiveScreenView extends GetView<LiveScreenController> {
  const LiveScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MaterialApp(
      title: 'Flutter Live Stream',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LiveStreamPage(),
    );
      },
    );
  }
}



