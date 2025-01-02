import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/tags_assignment/tags_assignment.dart';

class TagListItem extends StatelessWidget {
  final TagModel tag;
  final Widget? trailing;

  const TagListItem({super.key, required this.tag, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tag.code,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getCardTypeColor(tag.cardType),
                  ),
                ),
                if(tag.assignedVisitor != null)CardImage(imageString: tag.assignedVisitor!.picture, size: const Size(35,35), radius: 35,)
              ],
            ),
            const SizedBox(height: 8),

            // Assigned Visitor (if available)
            if (tag.assignedVisitor != null) ...[
              Text(
                'Assigned to: ${tag.assignedVisitor!.firstName} ${tag.assignedVisitor!.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CalendarUtils.timeToString(tag.timeOfAssignment, includeTime: true),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ] else ...[
              const Text(
                'Unassigned',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
            const SizedBox(height: 8),

            // Card Type and Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type: ${tag.cardType.toString().split('.').last}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Category: ${tag.cardCategory.toString().split('.').last}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            // Status of Assignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(tag),
                if(trailing !=null) trailing!
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TagModel card) {
    String statusText = card.assignedVisitor != null ? 'Assigned' : 'Unassigned';
    Color statusColor = card.assignedVisitor != null ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper function to determine color based on CardType
  Color _getCardTypeColor(CardType cardType) {
    switch (cardType) {
      case CardType.visitor:
        return Colors.blue;
      case CardType.vip:
        return Colors.green;
      case CardType.vvip:
        return Colors.orange;
      case CardType.vvvip:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
