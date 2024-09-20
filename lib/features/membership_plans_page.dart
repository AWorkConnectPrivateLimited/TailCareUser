import 'package:flutter/material.dart';

import 'membership_plan.dart'; // Import your model

class MembershipPlansPage extends StatelessWidget {
  final List<MembershipPlan> plans = [
    MembershipPlan(
      name: 'TailCare Gold',
      color: const Color(0xFFf2d49a),
      price: 299,
      benefits: ['Benefit 1', 'Benefit 2', 'Benefit 3'],
    ),
    // MembershipPlan(
    //   name: 'Silver',
    //   color: const Color(0xFFd8dbff),
    //   price: 199,
    //   benefits: ['Benefit 1', 'Benefit 2'],
    // ),
    // MembershipPlan(
    //   name: 'Bronze',
    //   color: Color(0xff000000),
    //   price: 99,
    //   benefits: ['Benefit 1', 'Benefit 2', 'Benefit 3', 'Benefit 4'],
    // ),
  ];

  MembershipPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Plans'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Set app bar color to blue
      ),
      backgroundColor: Colors.black, // Set background color to light grey
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return MembershipPlanCard(plan: plan);
        },
      ),
    );
  }
}

class MembershipPlanCard extends StatelessWidget {
  final MembershipPlan plan;

  MembershipPlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.black,
      elevation: 5.0,
      shadowColor: plan.color.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w700,
                color: plan.color,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '\₹ ${plan.price.toStringAsFixed(2)}/month',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            ...plan.benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: plan.color, size: 18.0),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          benefit,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle subscription logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: plan.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 40.0,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Choose ${plan.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
