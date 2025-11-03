import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onEdit;
  final bool isDark;
  final TextTheme txtTheme;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.onEdit,
    required this.isDark,
    required this.txtTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: tPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:txtTheme.bodyMedium?.copyWith(
                          color: tWhiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      email,
                      style: txtTheme.bodyMedium?.copyWith(color: tWhiteColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}