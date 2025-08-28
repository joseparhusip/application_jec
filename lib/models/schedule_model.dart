// models/schedule_model.dart

import 'package:flutter/material.dart';

class ScheduleItem {
  final String location;
  final String time;
  final String type;
  final int slots;
  final int bookedSlots;
  final IconData icon;
  final Color color;

  ScheduleItem({
    required this.location,
    required this.time,
    required this.type,
    required this.slots,
    required this.bookedSlots,
    required this.icon,
    required this.color,
  });
}