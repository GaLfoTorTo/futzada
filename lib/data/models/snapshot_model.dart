import 'package:futzada/core/enum/enums.dart';

class SnapshotModel {
  final SnapshotType type;
  final int gameId;
  final Map<String, dynamic> payload;

  const SnapshotModel({
    required this.type,
    required this.gameId,
    required this.payload,
  });

  factory SnapshotModel.fromMap(Map<String, dynamic> map) {
    return SnapshotModel(
      type: switch (map['type'] as String? ?? '') {
        'snapshot' => SnapshotType.snapshot,
        'action'   => SnapshotType.action,
        _          => SnapshotType.unknown,
      },
      gameId: map['game_id'] as int? ?? 0,
      payload: Map<String, dynamic>.from(map['payload'] as Map? ?? {}),
    );
  }
}