class TimelineDataEntity {
  final String? time;
  final int? count;

  TimelineDataEntity({
    this.time,
    this.count,
  });

  TimelineDataEntity copyWith({
    String? time,
    int? count,
  }) {
    return TimelineDataEntity(
      time: time ?? this.time,
      count: count ?? this.count,
    );
  }

  @override
  String toString() => 'TimelineDataEntity(time: $time, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimelineDataEntity && other.time == time && other.count == count;
  }

  @override
  int get hashCode => Object.hash(time, count);
}
