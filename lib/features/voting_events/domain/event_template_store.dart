import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../services/firebase_service.dart';
import 'voting_event.dart';

/// Device-local, organization-scoped starter templates. Voter IDs and dates
/// are deliberately excluded so templates cannot retain stale eligibility or
/// accidentally schedule an event in the past.
class EventTemplate {
  const EventTemplate({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.votingType,
    required this.privacyMode,
  });

  final String id;
  final String name;
  final String title;
  final String description;
  final VotingType votingType;
  final PrivacyMode privacyMode;

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'description': description,
        'votingType': votingType.name,
        'privacyMode': privacyMode.name,
      };

  factory EventTemplate.fromJson(Map<String, dynamic> json) => EventTemplate(
        id: json['id'] as String,
        name: json['name'] as String,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        votingType: VotingType.values.firstWhere(
          (value) => value.name == json['votingType'],
          orElse: () => VotingType.candidateElection,
        ),
        privacyMode: PrivacyMode.values.firstWhere(
          (value) => value.name == json['privacyMode'],
          orElse: () => PrivacyMode.anonymous,
        ),
      );
}

class EventTemplateStore {
  static const _uuid = Uuid();
  static const _maxTemplates = 20;

  static String _key(String organizationId) =>
      'raay_event_templates_${Uri.encodeComponent(organizationId)}';

  static Future<List<EventTemplate>> load(String organizationId) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key(organizationId)) ?? const [];
    final templates = <EventTemplate>[];
    for (final value in encoded) {
      try {
        templates.add(
            EventTemplate.fromJson(jsonDecode(value) as Map<String, dynamic>));
      } catch (_) {
        // Ignore malformed older local entries; a bad preference must not
        // prevent the election builder from opening.
      }
    }
    return templates;
  }

  static Future<EventTemplate> save({
    required String organizationId,
    required String name,
    required String title,
    required String description,
    required VotingType votingType,
    required PrivacyMode privacyMode,
  }) async {
    final templates = await load(organizationId);
    final template = EventTemplate(
      id: _uuid.v4(),
      name: name.trim(),
      title: title.trim(),
      description: description.trim(),
      votingType: votingType,
      privacyMode: privacyMode,
    );
    templates.insert(0, template);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key(organizationId),
      templates
          .take(_maxTemplates)
          .map((value) => jsonEncode(value.toJson()))
          .toList(),
    );
    return template;
  }

  static Future<void> delete(String organizationId, String id) async {
    final templates = await load(organizationId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key(organizationId),
      templates
          .where((value) => value.id != id)
          .map((value) => jsonEncode(value.toJson()))
          .toList(),
    );
  }
}

/// Organization-shared templates are stored through an authorization-checked
/// callable so they follow the user across devices without granting direct
/// Firestore access. Only setup copy and ballot mode are persisted.
class CloudEventTemplateStore {
  static Future<List<EventTemplate>> load(String organizationId) async {
    final response = await FirebaseService()
        .functions
        .httpsCallable('manageEventTemplates')
        .call({'organizationId': organizationId, 'action': 'list'});
    final data = Map<String, dynamic>.from(response.data as Map);
    final rows = data['templates'] as List? ?? const [];
    return rows
        .map((row) =>
            EventTemplate.fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  static Future<void> save({
    required String organizationId,
    required String name,
    required String title,
    required String description,
    required VotingType votingType,
    required PrivacyMode privacyMode,
  }) async {
    await FirebaseService()
        .functions
        .httpsCallable('manageEventTemplates')
        .call({
      'organizationId': organizationId,
      'action': 'save',
      'name': name,
      'title': title,
      'description': description,
      'votingType': votingType.name,
      'privacyMode': privacyMode.name,
    });
  }

  static Future<void> delete(String organizationId, String templateId) async {
    await FirebaseService()
        .functions
        .httpsCallable('manageEventTemplates')
        .call({
      'organizationId': organizationId,
      'action': 'delete',
      'templateId': templateId,
    });
  }
}
