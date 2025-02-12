import 'package:flutter/material.dart';
import 'package:untitled1/resourses/app_colors.dart';
import 'package:untitled1/screens/leadDetailsTabs.dart';
import 'package:untitled1/widget/sip_call_button.dart';

class LeadCard extends StatelessWidget {
  final  lead;
  final BuildContext context;

  const LeadCard({
    Key? key,
    required this.lead,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0.5,
          color: formBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeadDetailsTabs(leadId: lead.id!),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyAvatar(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.companyName ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildPipelineStatus(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDivider(),
                  const SizedBox(height: 16),
                  _buildAssigneeSection(),
                  const SizedBox(height: 16),
                  _buildActionSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          lead.companyName?.substring(0, 1).toUpperCase() ?? "C",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildPipelineStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timeline,
            size: 16,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            lead.leadPipelineName?.name ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildAssigneeSection() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.person,
            size: 16,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigned to',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              lead.assignName?.name ?? "",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildActionButton(
              icon: Icons.sip,
              onTap: () {
                // Wrap your SipCallButton functionality here
                SipCallButton(
                  phoneNumber: lead.phoneNumber.toString(),
                  callerName: lead.companyName.toString(),
                );
              },
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.mail_outline,
              onTap: () {
                // Add email functionality
              },
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.chat_bubble_outline,
              onTap: () {
                // Add chat functionality
              },
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}