import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/call_detection_service.dart';
import '../widgets/simple_call_popup.dart';

class CallDetectionTestPage extends StatefulWidget {
  const CallDetectionTestPage({Key? key}) : super(key: key);

  @override
  State<CallDetectionTestPage> createState() => _CallDetectionTestPageState();
}

class _CallDetectionTestPageState extends State<CallDetectionTestPage> {
  final TextEditingController _phoneController = TextEditingController();
  final CallDetectionService _callDetectionService =
      Get.find<CallDetectionService>();
  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  Future<void> _checkServiceStatus() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking service status...';
    });

    try {
      if (!_callDetectionService.isInitialized) {
        setState(() {
          _status = 'Service not initialized. Initializing...';
        });

        try {
          await _callDetectionService.initialize();
          setState(() {
            _status = 'Service initialized successfully.';
          });
        } catch (e) {
          setState(() {
            _status = 'Error initializing service: $e\nTrying to continue...';
          });
        }
      }

      // Check overlay permission separately
      bool hasOverlayPermission = false;
      try {
        hasOverlayPermission =
            await _callDetectionService.checkOverlayPermission();
      } catch (e) {
        setState(() {
          _status += '\nError checking overlay permission: $e';
        });
      }

      setState(() {
        _status += '\nLeads loaded: ${_callDetectionService.leads.length}\n'
            'Overlay permission: ${hasOverlayPermission ? 'GRANTED' : 'DENIED or UNKNOWN'}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _reloadLeads() async {
    setState(() {
      _isLoading = true;
      _status = 'Reloading leads...';
    });

    try {
      await _callDetectionService.refreshLeads();
      setState(() {
        _status =
            'Leads reloaded. Count: ${_callDetectionService.leads.length}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error reloading leads: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCallDetection() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _status = 'Please enter a phone number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Testing call detection with number: $phoneNumber';
    });

    try {
      await _callDetectionService.testCallDetection(phoneNumber);
      setState(() {
        _status = 'Test completed. Check logs for details.';
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

  void _testSimplePopup() {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _status = 'Please enter a phone number';
      });
      return;
    }

    Get.bottomSheet(
      SimpleCallPopup(phoneNumber: phoneNumber),
      isDismissible: true,
      enableDrag: true,
    );
  }

  Future<void> _testBackgroundService() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _status = 'Please enter a phone number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Testing background service with number: $phoneNumber';
    });

    try {
      await _callDetectionService.testBackgroundService(phoneNumber);
      setState(() {
        _status = 'Background service test completed. Check logs and overlay.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error testing background service: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCallStateReceiver() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _status = 'Please enter a phone number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Testing CallStateReceiver with number: $phoneNumber';
    });

    try {
      await _callDetectionService.testCallStateReceiver(phoneNumber);
      setState(() {
        _status = 'CallStateReceiver test completed. Check logs and overlay.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error testing CallStateReceiver: $e';
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
        _status =
            'Phone state listener service started successfully. Now try making a real call.';
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

  Future<void> _checkPhoneListenerStatus() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking phone state listener service status...';
    });

    try {
      final isRunning =
          await _callDetectionService.checkPhoneStateListenerStatus();
      setState(() {
        _status =
            'Phone state listener service is ${isRunning ? 'RUNNING' : 'NOT RUNNING'}.\n'
            '${isRunning ? 'Service is active and monitoring calls.' : 'Service needs to be started.'}';
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

  Future<void> _requestOverlayPermission() async {
    setState(() {
      _isLoading = true;
      _status = 'Requesting overlay permission...';
    });

    try {
      // Make sure service is initialized first
      if (!_callDetectionService.isInitialized) {
        setState(() {
          _status = 'Initializing service first...';
        });
        try {
          await _callDetectionService.initialize();
        } catch (e) {
          setState(() {
            _status = 'Error initializing service: $e\nTrying to continue...';
          });
        }
      }

      // Now request permission
      try {
        await _callDetectionService.requestOverlayPermission();
        setState(() {
          _status += '\nPermission request sent. Check system settings.';
        });
      } catch (e) {
        setState(() {
          _status += '\nError requesting permission: $e';
        });
      }

      // Check if permission was granted
      try {
        final hasPermission =
            await _callDetectionService.checkOverlayPermission();
        setState(() {
          _status +=
              '\nOverlay permission: ${hasPermission ? 'GRANTED' : 'DENIED'}';
        });
      } catch (e) {
        setState(() {
          _status += '\nError checking permission: $e';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Detection Test'),
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
                    const Text(
                      'Service Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _checkServiceStatus,
                      child: const Text('Check Status'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _reloadLeads,
                      child: const Text('Reload Leads'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _requestOverlayPermission,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Request Overlay Permission'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _startPhoneStateListener,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Start Phone Listener'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _checkPhoneListenerStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Check Service Status'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Call Detection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter a phone number to test',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _testCallDetection,
                            child: const Text('Test Call Detection'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _testSimplePopup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Test Simple Popup'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _testBackgroundService,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Test Background Service'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _testCallStateReceiver,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Test Call Receiver'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
