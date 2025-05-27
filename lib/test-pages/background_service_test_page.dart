import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/call_detection_service.dart';

class BackgroundServiceTestPage extends StatefulWidget {
  const BackgroundServiceTestPage({Key? key}) : super(key: key);

  @override
  State<BackgroundServiceTestPage> createState() =>
      _BackgroundServiceTestPageState();
}

class _BackgroundServiceTestPageState extends State<BackgroundServiceTestPage> {
  final CallDetectionService _callDetectionService =
      Get.find<CallDetectionService>();
  bool _isLoading = false;
  String _status = 'Ready to test background service';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Service Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Background Service Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _status,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Service Control Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _checkServiceStatus,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Check Service Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _startPhoneStateListener,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Phone State Listener'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _stopPhoneStateListener,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop Phone State Listener'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Permission Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Permissions & Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed:
                          _isLoading ? null : _requestBatteryOptimization,
                      icon: const Icon(Icons.battery_saver),
                      label: const Text('Battery Optimization'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed:
                          _isLoading ? null : _requestAutoStartPermission,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Auto-Start Permission'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed:
                          _isLoading ? null : _showBackgroundNotification,
                      icon: const Icon(Icons.notifications),
                      label: const Text('Show Background Notification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _resetPermissionFlags,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Permission Flags (Test)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Test Call Detection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Call Detection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () => _testCallDetection('01645467222'),
                      icon: const Icon(Icons.phone),
                      label: const Text('Test with Sample Number'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkServiceStatus() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking service status...';
    });

    try {
      final isRunning =
          await _callDetectionService.checkPhoneStateListenerStatus();
      setState(() {
        _status = isRunning
            ? 'Phone State Listener Service is RUNNING ✅'
            : 'Phone State Listener Service is NOT RUNNING ❌';
      });
    } catch (e) {
      setState(() {
        _status = 'Error checking service status: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _startPhoneStateListener() async {
    setState(() {
      _isLoading = true;
      _status = 'Starting phone state listener service...';
    });

    try {
      await _callDetectionService.startPhoneStateListener();
      setState(() {
        _status = 'Phone state listener service started successfully ✅';
      });
    } catch (e) {
      setState(() {
        _status = 'Error starting phone state listener service: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _stopPhoneStateListener() async {
    setState(() {
      _isLoading = true;
      _status = 'Stopping phone state listener service...';
    });

    try {
      await _callDetectionService.stopPhoneStateListener();
      setState(() {
        _status = 'Phone state listener service stopped ⏹️';
      });
    } catch (e) {
      setState(() {
        _status = 'Error stopping phone state listener service: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestBatteryOptimization() async {
    setState(() {
      _isLoading = true;
      _status = 'Requesting battery optimization exemption...';
    });

    try {
      await _callDetectionService.requestBatteryOptimizationExemption();
      setState(() {
        _status =
            'Battery optimization exemption requested. Please grant permission in settings.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error requesting battery optimization exemption: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestAutoStartPermission() async {
    setState(() {
      _isLoading = true;
      _status = 'Requesting auto-start permission...';
    });

    try {
      await _callDetectionService.requestAutoStartPermission();
      setState(() {
        _status =
            'Auto-start permission requested. Please enable in device settings.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error requesting auto-start permission: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showBackgroundNotification() async {
    setState(() {
      _isLoading = true;
      _status = 'Showing background operation notification...';
    });

    try {
      await _callDetectionService.showBackgroundOperationNotification();
      setState(() {
        _status = 'Background operation notification shown ✅';
      });
    } catch (e) {
      setState(() {
        _status = 'Error showing background notification: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCallDetection(String phoneNumber) async {
    setState(() {
      _isLoading = true;
      _status = 'Testing call detection with number: $phoneNumber';
    });

    try {
      await _callDetectionService.testCallDetection(phoneNumber);
      setState(() {
        _status = 'Call detection test completed. Check if overlay appeared.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error testing call detection: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPermissionFlags() async {
    setState(() {
      _isLoading = true;
      _status = 'Resetting permission flags...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('has_requested_auto_start');
      await prefs.remove('has_shown_background_notification');
      setState(() {
        _status =
            'Permission flags reset. App will request permissions again on next start.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error resetting permission flags: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
