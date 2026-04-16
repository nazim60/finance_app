import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  final String insight;
  const InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.teal),
          SizedBox(width: 12),
          Expanded(child: Text(insight, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
