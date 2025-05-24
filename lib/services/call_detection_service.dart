import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/LeadListModel.dart';
import '../widgets/call_popup_widget.dart';
import '../widgets/simple_call_popup.dart';
import '../widgets/system_overlay_widget.dart';
import 'mock_lead_provider.dart';
import 'package:flutter/material.dart';

class CallDetectionService extends GetxController {
  static CallDetectionService get instance => Get.find<CallDetectionService>();

  final MethodChannel _channel =
      const MethodChannel('com.example.untitled1/call_detection');
  final RxList<LeadListModel> _leads = <LeadListModel>[].obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _hasOverlayPermission = false.obs;

  // Getter for leads
  List<LeadListModel> get leads => _leads;
  bool get isInitialized => _isInitialized.value;
  bool get hasOverlayPermission => _hasOverlayPermission.value;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized.value) return;

    // Set up method channel handler first
    _channel.setMethodCallHandler(_handleMethodCall);

    // Start call detection
    await _channel.invokeMethod('startCallDetection');

    // Now check overlay permission
    await checkOverlayPermission();

    // Request overlay permission if not granted
    if (!_hasOverlayPermission.value) {
      await requestOverlayPermission();
    }

    // Load leads
    await loadLeads();

    // Set up a periodic task to refresh leads every 30 minutes
    Timer.periodic(Duration(minutes: 30), (timer) async {
      print('Refreshing leads from API...');
      await loadLeads();
    });

    _isInitialized.value = true;
  }

  // Check if overlay permission is granted
  Future<bool> checkOverlayPermission() async {
    try {
      final hasPermission =
          await _channel.invokeMethod('checkOverlayPermission') as bool;
      _hasOverlayPermission.value = hasPermission;
      print('Overlay permission: ${hasPermission ? 'GRANTED' : 'DENIED'}');
      return hasPermission;
    } catch (e) {
      print('Error checking overlay permission: $e');
      // Default to false if there's an error
      _hasOverlayPermission.value = false;
      return false;
    }
  }

  // Request overlay permission
  Future<void> requestOverlayPermission() async {
    try {
      await _channel.invokeMethod('requestOverlayPermission');
      // Check if permission was granted
      await checkOverlayPermission();
    } catch (e) {
      print('Error requesting overlay permission: $e');
    }
  }

  // Handle method calls from native side
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onCallEnded':
        final phoneNumber = call.arguments as String;
        await _handleCallEnded(phoneNumber);
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  // Method to manually test the call detection feature
  Future<void> testCallDetection(String phoneNumber) async {
    print('Testing call detection with number: $phoneNumber');
    await _handleCallEnded(phoneNumber);
  }

  // Load leads from API or local storage
  Future<void> loadLeads() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("token");
      String? userId = sharedPreferences.getString("id");

      if (token == null || userId == null) {
        print('No authentication token or user ID found');
        // Use mock data if no token is available
        _loadMockLeads();
        return;
      }

      // Use the same API endpoint and parameters as in totalLeadList.dart
      final response = await http.post(
        Uri.parse('https://crm.ihelpbd.com/api/crm-lead-data-show'),
        headers: {
          'Authorization': 'Bearer $token',
          'user_id': '$userId',
        },
        body: {
          'start_date': '',
          'end_date': '',
          'user_id_search': userId,
          'session_user_id': userId,
          'lead_pipeline_id': '',
          'lead_source_id': '',
          'searchData': '',
          'is_type': '0',
          'page': '1',
          'per_page': '100',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Successfully loaded leads from API');

        // Extract leads from the response - handle both data formats
        final List<dynamic> leadsData = data['data'] is Map
            ? data['data']['data'] ?? []
            : data['data'] ?? [];

        _leads.value = leadsData
            .map((leadData) {
              try {
                return LeadListModel.fromJson(leadData);
              } catch (e) {
                print('Error parsing lead: $e');
                return null;
              }
            })
            .whereType<LeadListModel>()
            .toList();

        print('Loaded ${_leads.length} leads from API');

        // Cache the leads for offline use
        sharedPreferences.setString('cached_leads', json.encode(leadsData));

        // Store a simplified version of leads with just name, phone, and ID for faster lookup
        final List<Map<String, dynamic>> simplifiedLeads = _leads
            .map((lead) => {
                  'id': lead.id,
                  'name': lead.name,
                  'phoneNumber': _normalizePhoneNumber(lead.phoneNumber ?? ''),
                  'companyName': lead.companyName,
                  'leadPipelineName': lead.leadPipelineName?.name,
                  'assignName': lead.assignName?.name,
                })
            .toList();

        sharedPreferences.setString(
            'simplified_leads', json.encode(simplifiedLeads));
        print(
            'Stored ${simplifiedLeads.length} simplified leads in local storage');
      } else {
        print('Failed to load leads: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Try to load leads from a local backup if available
        await _loadLeadsFromLocal();
      }
    } catch (e) {
      print('Error loading leads: $e');
      // Try to load leads from a local backup if available
      await _loadLeadsFromLocal();
    }
  }

  // Load leads from local storage as a fallback
  Future<void> _loadLeadsFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final leadsJson = prefs.getString('cached_leads');

      if (leadsJson != null) {
        final leadsData = json.decode(leadsJson) as List<dynamic>;
        _leads.value = leadsData
            .map((leadData) => LeadListModel.fromJson(leadData))
            .toList();
        print('Loaded ${_leads.length} leads from local cache');
      } else {
        // If no cached leads, use mock data
        _loadMockLeads();
      }
    } catch (e) {
      print('Error loading leads from local cache: $e');
      // If loading from cache fails, use mock data
      _loadMockLeads();
    }
  }

  // Load mock leads for testing
  void _loadMockLeads() {
    _leads.value = MockLeadProvider.getMockLeads();
    print('Loaded ${_leads.length} mock leads for testing');
  }

  // Find a lead with matching phone number
  Future<LeadListModel?> _findMatchingLead(String phoneNumber) async {
    try {
      // Get leads from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? leadsJson = prefs.getString('cached_leads');

      if (leadsJson != null) {
        List<dynamic> leadsData = jsonDecode(leadsJson);
        List<LeadListModel> leads =
            leadsData.map((e) => LeadListModel.fromJson(e)).toList();

        String normalizedNumber = _normalizePhoneNumber(phoneNumber);

        // Find matching lead
        return leads.firstWhere(
          (lead) =>
              _normalizePhoneNumber(lead.phoneNumber ?? '') == normalizedNumber,
          orElse: () => throw StateError('No matching lead found'),
        );
      }
    } catch (e) {
      print('Error finding matching lead: $e');
    }
    return null;
  }

  // Check if two phone numbers match
  bool _isPhoneNumberMatch(String number1, String number2) {
    // If either number is empty, no match
    if (number1.isEmpty || number2.isEmpty) return false;

    // Normalize both numbers to remove any formatting
    number1 = _normalizePhoneNumber(number1);
    number2 = _normalizePhoneNumber(number2);

    // Direct match
    if (number1 == number2) return true;

    // For Bangladesh numbers:
    // 1. Handle numbers with/without leading zero
    // 2. Handle numbers with/without country code (88)
    // 3. Match the last significant digits

    // Remove leading zeros
    number1 = number1.replaceFirst(RegExp(r'^0+'), '');
    number2 = number2.replaceFirst(RegExp(r'^0+'), '');

    // Remove Bangladesh country code if present
    number1 = number1.replaceFirst(RegExp(r'^88'), '');
    number2 = number2.replaceFirst(RegExp(r'^88'), '');

    // If we have at least 10 digits, compare the last 10
    if (number1.length >= 10 && number2.length >= 10) {
      final last10Digits1 = number1.substring(number1.length - 10);
      final last10Digits2 = number2.substring(number2.length - 10);
      return last10Digits1 == last10Digits2;
    }

    // For shorter numbers, compare directly
    return number1 == number2;
  }

  // Normalize phone number by removing non-digit characters and standardizing format
  String _normalizePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return '';

    // Remove all non-digit characters except +
    String normalized = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Handle international format
    if (normalized.startsWith('+')) {
      normalized = normalized.substring(1); // Remove the +
    }

    // Handle Bangladesh country code
    if (normalized.startsWith('88') && normalized.length > 2) {
      normalized = normalized.substring(2);
    }

    // Ensure the number follows Bangladesh mobile number format (11 digits starting with 01)
    if (normalized.length == 10 && !normalized.startsWith('0')) {
      normalized = '0$normalized';
    }

    print("Normalized phone number: $phoneNumber -> $normalized");
    return normalized;
  }

  // Find a matching lead in local storage
  Future<LeadListModel?> _findMatchingLeadInLocalStorage(
      String normalizedNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final simplifiedLeadsJson = prefs.getString('simplified_leads');

      if (simplifiedLeadsJson != null) {
        final simplifiedLeads =
            json.decode(simplifiedLeadsJson) as List<dynamic>;

        for (var leadData in simplifiedLeads) {
          final leadNumber = leadData['phoneNumber'] as String? ?? '';

          if (leadNumber.isNotEmpty &&
              _isPhoneNumberMatch(leadNumber, normalizedNumber)) {
            print(
                "Found matching lead in local storage: ${leadData['name']}, number: $leadNumber");

            // Create a LeadListModel from the simplified data
            return LeadListModel(
              id: leadData['id'] as int? ?? 0,
              name: leadData['name'] as String? ?? 'Unknown',
              phoneNumber: leadNumber,
              companyName: leadData['companyName'] as String? ?? '',
              associates: [], // Add empty associates list
              leadPipelineId: 0,
              leadAreaId: 0,
              userId: 0,
              createdAt: '',
              amount: '',
              leadSourceId: 0,
            );
          }
        }
      }

      print("No matching lead found in local storage");
      return null;
    } catch (e) {
      print("Error finding lead in local storage: $e");
      return null;
    }
  }

  // Handle call ended event
  Future<void> _handleCallEnded(String phoneNumber) async {
    print('Call ended with number: $phoneNumber');

    // Normalize phone number (remove spaces, dashes, etc.)
    final normalizedNumber = _normalizePhoneNumber(phoneNumber);
    print('Normalized number: $normalizedNumber');

    // Find matching lead
    final matchingLead = await _findMatchingLead(normalizedNumber);

    // Update the overlay with lead information if found
    if (matchingLead != null) {
      print('Found matching lead:');
      print('  - ID: ${matchingLead.id}');
      print('  - Name: ${matchingLead.name}');
      print('  - Phone: ${matchingLead.phoneNumber}');
      print('  - Company: ${matchingLead.companyName}');

      // Show the overlay for the matching lead
      try {
        await _channel.invokeMethod('showOverlayForLead', {
          'phoneNumber': normalizedNumber,
          'leadName': matchingLead.companyName ?? 'Unknown Company',
          'leadId': matchingLead.id,
          'hasMatchingLead': true,
          'leadPipeline': matchingLead.leadPipelineName?.name ?? 'N/A',
          'assignedUser': matchingLead.assignName?.name ?? 'N/A',
          'actions': [
            {
              'type': 'update_pipeline',
              'label': 'Update Pipeline',
              'icon': 'update'
            },
            {'type': 'create_task', 'label': 'Create Task', 'icon': 'task'},
            {
              'type': 'create_followup',
              'label': 'Create Follow-up',
              'icon': 'followup'
            },
            {'type': 'make_note', 'label': 'Make Note', 'icon': 'note'},
            {'type': 'call_again', 'label': 'Call Again', 'icon': 'call'},
            {'type': 'view_details', 'label': 'View Details', 'icon': 'info'}
          ]
        });
        print('Sent lead information to native side and showed overlay');
      } catch (e) {
        print('Error showing overlay for lead: $e');
      }

      // Show popup with lead information
      _showLeadPopup(matchingLead);
    } else {
      print('No matching lead found for number: $normalizedNumber');
      print('Available leads: ${_leads.length}');
      if (_leads.isNotEmpty) {
        print('Sample lead numbers:');
        for (int i = 0; i < min(5, _leads.length); i++) {
          final lead = _leads[i];
          final leadNumber = _normalizePhoneNumber(lead.phoneNumber ?? '');
          print('  - ${lead.companyName}: ${lead.phoneNumber} -> $leadNumber');
        }
      }

      // Don't show any overlay for unmatched numbers
      print(
          'No matching lead found for number: $normalizedNumber - skipping overlay');

      // Removed overlay update for unknown contacts
      // Removed call to _showGenericPopup()
    }
  }

  // Show popup with lead information
  void _showLeadPopup(LeadListModel lead) {
    Get.bottomSheet(
      SystemOverlayWidget(lead: lead),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Show a generic popup for any call
  void _showGenericPopup(String phoneNumber) {
    // Show the simple popup
    Get.bottomSheet(
      SimpleCallPopup(phoneNumber: phoneNumber),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Manually refresh leads from API
  Future<void> refreshLeads() async {
    print('Manually refreshing leads from API...');
    await loadLeads();
  }

  // Dismiss the overlay
  Future<void> dismissOverlay() async {
    try {
      await _channel.invokeMethod('dismissOverlay');
      print('Overlay dismissed successfully');
    } catch (e) {
      print('Error dismissing overlay: $e');
    }
  }

  // Dispose resources
  @override
  void onClose() {
    _channel.invokeMethod('stopCallDetection');
    super.onClose();
  }

  void onCallStateChanged(String phoneNumber, int state) async {
    if (state == 2) {
      // Call Ended
      String normalizedNumber = _normalizePhoneNumber(phoneNumber);

      // Find matching lead from local storage
      LeadListModel? matchingLead = await _findMatchingLead(normalizedNumber);

      if (matchingLead != null) {
        try {
          // Only show the overlay when there's a matching lead
          await _channel.invokeMethod('showOverlayForLead', {
            'phoneNumber': normalizedNumber,
            'leadName': matchingLead.companyName ?? 'Unknown Company',
            'leadId': matchingLead.id,
            'hasMatchingLead': true,
            'leadPipeline': matchingLead.leadPipelineName?.name ?? 'N/A',
            'assignedUser': matchingLead.assignName?.name ?? 'N/A',
            'actions': [
              {
                'type': 'update_pipeline',
                'label': 'Update Pipeline',
                'icon': 'update'
              },
              {'type': 'create_task', 'label': 'Create Task', 'icon': 'task'},
              {
                'type': 'create_followup',
                'label': 'Create Follow-up',
                'icon': 'followup'
              },
              {'type': 'make_note', 'label': 'Make Note', 'icon': 'note'},
              {'type': 'call_again', 'label': 'Call Again', 'icon': 'call'},
              {'type': 'view_details', 'label': 'View Details', 'icon': 'info'}
            ]
          });

          // Show Flutter popup with lead information
          _showLeadPopup(matchingLead);
        } catch (e) {
          print('Error showing overlay for lead: $e');
        }
      } else {
        // No matching lead found - don't show any popup
        print(
            'No matching lead found for number: $normalizedNumber - skipping overlay');
        // Removed call to _showGenericPopup()
      }
    }
  }
}
