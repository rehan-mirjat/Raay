import 'package:flutter/material.dart';

/// A wrapper for premium icons. 
/// NOTE: The 'lucide_icons' package currently breaks Flutter Web builds 
/// due to IconData being marked as final in recent Flutter SDKs. 
/// We fallback to equivalent Material Rounded icons safely here.
class KivoraIcons {
  static const IconData vote = Icons.how_to_vote_rounded;
  static const IconData user = Icons.person_outline_rounded;
  static const IconData userPlus = Icons.person_add_outlined;
  static const IconData users = Icons.groups_outlined;
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData mail = Icons.email_outlined;
  static const IconData eye = Icons.visibility_outlined;
  static const IconData eyeOff = Icons.visibility_off_outlined;
  static const IconData shieldCheck = Icons.shield_outlined;
  static const IconData building = Icons.business_rounded;
  static const IconData building2 = Icons.apartment_outlined;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData calendarClock = Icons.event_available_outlined;
  static const IconData calendarX = Icons.event_busy_outlined;
  static const IconData barChart2 = Icons.bar_chart_rounded;
  static const IconData plus = Icons.add_rounded;
  static const IconData plusSquare = Icons.add_box_outlined;
  static const IconData logIn = Icons.login_rounded;
  static const IconData settings = Icons.settings_outlined;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData qrCode = Icons.qr_code_2_rounded;
  static const IconData network = Icons.account_tree_outlined;
  static const IconData history = Icons.history_rounded;
  static const IconData userCheck = Icons.how_to_reg_outlined;
  static const IconData search = Icons.search_rounded;
  static const IconData checkCircle = Icons.check_circle_outline_rounded;
  static const IconData alertCircle = Icons.error_outline_rounded;
}
