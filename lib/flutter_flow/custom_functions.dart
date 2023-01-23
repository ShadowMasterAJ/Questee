import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import '../backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/auth_util.dart';

bool searchJobs(
  String? searchInput,
  String? searchPool,
) {
  // search for existence of the string in job locations
  if (searchInput == null || searchPool == null) {
    return false;
  }
  if (searchInput.isNotEmpty) {
    final String regex = RegExp(searchInput, caseSensitive: false).pattern;
    if (RegExp(regex).hasMatch(searchPool)) {
      return true;
    }
  }
  return false;
}
