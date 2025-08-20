import 'package:flutter/material.dart';

enum NotificationType {
  jobMatch,
  jobApplication,
  jobInterview,
  jobOffer,
  serviceProviderRouting,
  serviceProviderQuotation,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  // Additional fields for specific notification types
  final String? companyName;
  final DateTime? eventDate;
  final String? serviceProviderName;
  final String? serviceType;
  final String? trackingLink;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.companyName,
    this.eventDate,
    this.serviceProviderName,
    this.serviceType,
    this.trackingLink,
  });
}