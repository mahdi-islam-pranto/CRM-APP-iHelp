import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'call_detection_service.dart';

class ServiceInitializer extends StatefulWidget {
  final Widget child;

  const ServiceInitializer({Key? key, required this.child}) : super(key: key);

  @override
  State<ServiceInitializer> createState() => _ServiceInitializerState();
}

class _ServiceInitializerState extends State<ServiceInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize call detection service
      await Get.find<CallDetectionService>().initialize();
    } catch (e) {
      debugPrint('Error initializing services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
