import 'package:start_algorithm/entity/node_entity.dart';

class MovementEntity {
  final NodeEntity node;
  final NodeEntity parent;
  final int movementCost;
  final double heuristicCost;
  final double totalCost;

  MovementEntity({
    required this.node,
    required this.parent,
    required this.movementCost,
    required this.heuristicCost,
    required this.totalCost,
  });

  @override
  String toString() {
    return 'MovementEntity{node: $node, movementCost: $movementCost, heuristicCost: $heuristicCost, totalCost: $totalCost}';
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is MovementEntity && runtimeType == other.runtimeType && node == other.node && movementCost == other.movementCost && heuristicCost == other.heuristicCost && totalCost == other.totalCost;

  @override
  int get hashCode => node.hashCode ^ movementCost.hashCode ^ heuristicCost.hashCode ^ totalCost.hashCode;

  MovementEntity copyWith({
    int? movementCost,
    double? heuristicCost,
    double? totalCost,
  }) {
    return MovementEntity(
      parent: parent,
      node: node,
      movementCost: movementCost ?? this.movementCost,
      heuristicCost: heuristicCost ?? this.heuristicCost,
      totalCost: totalCost ?? this.totalCost,
    );
  }
}
