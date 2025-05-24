import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/FollowUP/followUpCreateForm.dart';
import 'package:untitled1/Task/leadTaskCreateForm.dart';
import '../FollowUP/leadFollowUpCreate.dart';
import '../Models/LeadListModel.dart';
import '../screens/leadDetailsTabs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class SystemOverlayWidget extends StatelessWidget {
  final LeadListModel lead;

  const SystemOverlayWidget({Key? key, required this.lead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Company Name and Phone
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.companyName ?? 'Unknown Company',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead.phoneNumber ?? 'No number',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const Divider(height: 24),

          // Pipeline Section
          Row(
            children: [
              Icon(Icons.account_tree, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pipeline',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      lead.leadPipelineName?.name ?? 'N/A',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement pipeline update
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Update'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Assigned User Section
          Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assigned To',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      lead.assignName?.name ?? 'N/A',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement pipeline update
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Update'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Created Time Section
          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      lead.leadPipelineName?.createdAt != null
                          ? DateFormat.yMd().add_jm().format(
                              DateTime.parse(lead.leadPipelineName!.createdAt!))
                          : 'N/A',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            children: [
              _buildActionButton(
                context,
                Icons.task_alt,
                'Create Task',
                Colors.blue,
                () {
                  // TODO: Implement create task
                  Get.back();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeadTaskCreateForm(leadId: lead.id),
                    ),
                  );
                },
              ),
              _buildActionButton(
                context,
                Icons.update,
                'Follow-up',
                Colors.orange,
                () {
                  // TODO: Implement create follow-up
                  Get.back();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeadFollowUpCreate(leadId: lead.id),
                    ),
                  );
                },
              ),
              _buildActionButton(
                context,
                Icons.note_add,
                'Make Note',
                Colors.purple,
                () {
                  // TODO: Implement make note
                },
              ),
              _buildActionButton(
                context,
                Icons.call,
                'Call Again',
                Colors.green,
                () async {
                  final Uri uri = Uri.parse('tel:${lead.phoneNumber}');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
              _buildActionButton(
                context,
                Icons.info_outline,
                'View Details',
                Colors.blue,
                () {
                  Get.back();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeadDetailsTabs(leadId: lead.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
