import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/screens/leadDetailsTabs.dart';
import '../Models/LeadListModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Lead/leadOverview.dart';

class CallPopupWidget extends StatelessWidget {
  final LeadListModel lead;

  const CallPopupWidget({Key? key, required this.lead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lead Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          if (lead.companyName != null && lead.companyName!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.business, 'Company', lead.companyName ?? 'N/A'),
          ],
          const SizedBox(height: 20),
          _buildInfoRow(Icons.phone, 'Phone', lead.phoneNumber ?? 'N/A'),
          const SizedBox(height: 20),
          if (lead.email != null && lead.email!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'Email', lead.email ?? 'N/A'),
            const SizedBox(height: 20),
          ],
          _buildInfoRow(Icons.check_box_outlined, 'Pipeline',
              lead.leadPipelineName?.name ?? 'N/A'),
          const SizedBox(height: 20),
          _buildInfoRow(
              Icons.person, 'Assigned to ', lead.assignName?.name ?? 'N/A'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                Icons.call,
                'Call Back',
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
                  Get.back(); // Close the popup
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: onPressed,
    );
  }
}
