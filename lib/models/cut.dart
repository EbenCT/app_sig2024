class Cut {
  final int id;
  final String location;
  final bool completed;
  final bool failed;

  Cut({
    required this.id,
    required this.location,
    this.completed = false,
    this.failed = false,
  });

  factory Cut.fromJson(Map<String, dynamic> json) {
    return Cut(
      id: json['id'],
      location: json['location'],
      completed: json['completed'],
      failed: json['failed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'completed': completed,
      'failed': failed,
    };
  }
}
