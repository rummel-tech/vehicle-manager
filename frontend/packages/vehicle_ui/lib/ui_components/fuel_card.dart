import 'package:flutter/material.dart';

class FuelCard extends StatelessWidget {
  final String date;
  final int mileage;
  final double gallons;
  final double cost;
  final double? pricePerGallon;
  final double? mpg;
  final VoidCallback? onTap;

  const FuelCard({
    super.key,
    required this.date,
    required this.mileage,
    required this.gallons,
    required this.cost,
    this.pricePerGallon,
    this.mpg,
    this.onTap,
  });

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
                backgroundColor: Colors.orange.shade100,
                child: const Icon(
                  Icons.local_gas_station,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
                        if (mpg != null) ...[
                          const SizedBox(width: 12),
                          Text(
                            '${mpg!.toStringAsFixed(1)} MPG',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${gallons.toStringAsFixed(2)} gal',
                          style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                        ),
                        if (pricePerGallon != null) ...[
                          Text(
                            ' @ \$${pricePerGallon!.toStringAsFixed(2)}/gal',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '\$${cost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
