import 'package:flutter/material.dart';

class MaintenanceCard extends StatelessWidget {
  final String type;
  final String date;
  final int mileage;
  final double? cost;
  final String? description;
  final int? nextDueMileage;
  final VoidCallback? onTap;

  const MaintenanceCard({
    super.key,
    required this.type,
    required this.date,
    required this.mileage,
    this.cost,
    this.description,
    this.nextDueMileage,
    this.onTap,
  });

  IconData _getTypeIcon() {
    switch (type) {
      case 'oil_change':
        return Icons.oil_barrel;
      case 'tire_rotation':
        return Icons.album;
      case 'brake_service':
        return Icons.branding_watermark;
      case 'inspection':
        return Icons.checklist;
      case 'repair':
        return Icons.build;
      default:
        return Icons.build_circle;
    }
  }

  String _getTypeLabel() {
    switch (type) {
      case 'oil_change':
        return 'Oil Change';
      case 'tire_rotation':
        return 'Tire Rotation';
      case 'brake_service':
        return 'Brake Service';
      case 'inspection':
        return 'Inspection';
      case 'repair':
        return 'Repair';
      default:
        return type.replaceAll('_', ' ').toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  _getTypeIcon(),
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTypeLabel(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (description != null && description!.isNotEmpty)
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.speed, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${mileage.toStringAsFixed(0)} mi',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                        if (nextDueMileage != null) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.event, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Next: ${nextDueMileage} mi',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (cost != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${cost!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
