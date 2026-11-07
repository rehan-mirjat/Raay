class ContestChoice {
  const ContestChoice(
      {required this.id, required this.label, this.description = ''});
  final String id;
  final String label;
  final String description;
  factory ContestChoice.fromMap(Map data) => ContestChoice(
      id: data['id'] as String,
      label: data['label'] as String,
      description: data['description'] as String? ?? '');
  Map<String, dynamic> toMap() =>
      {'id': id, 'label': label, 'description': description};
}

class ElectionContest {
  const ElectionContest(
      {required this.id, required this.title, required this.choices});
  final String id;
  final String title;
  final List<ContestChoice> choices;
  factory ElectionContest.fromMap(Map data) => ElectionContest(
      id: data['id'] as String,
      title: data['title'] as String,
      choices: (data['choices'] as List)
          .map((c) => ContestChoice.fromMap(c as Map))
          .toList());
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'choices': choices.map((c) => c.toMap()).toList()
      };
}
