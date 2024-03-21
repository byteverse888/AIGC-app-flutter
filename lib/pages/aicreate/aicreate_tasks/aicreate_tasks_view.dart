import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'aicreate_tasks_logic.dart';

class AICreateTasksPage extends StatelessWidget {
  final logic = Get.find<AICreateTasksLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的任务'),),
    );
  }
}
