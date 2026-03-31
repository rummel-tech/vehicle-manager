import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String make;
  final String model;
  final int year;
  final int currentMileage;
  final String? color;
  final String? licensePlate;
  final String? vehicleType;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.make,
    required this.model,
    required this.year,
    required this.currentMileage,
    this.color,
    this.licensePlate,
    this.vehicleType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  _getVehicleIcon(),
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$year $make $model',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (licensePlate != null)
                      Text(
                        licensePlate!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.speed, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${currentMileage.toStringAsFixed(0)} mi',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        if (color != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getColorFromName(color!),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            color!,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getVehicleIcon() {
    switch (vehicleType?.toLowerCase()) {
      case 'motorcycle':
        return Icons.two_wheeler;
      case 'truck':
        return Icons.local_shipping;
      case 'suv':
        return Icons.directions_car;
      case 'van':
        return Icons.airport_shuttle;
      case 'car':
      default:
        return Icons.directions_car;
    }
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
