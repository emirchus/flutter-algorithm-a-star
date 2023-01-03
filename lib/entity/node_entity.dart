class NodeEntity {
  final int id;
  final double x, y, width, height;
  final NodeEntityStatus status;
  bool isOpen = false;

  NodeEntity({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.status = NodeEntityStatus.path,
    this.isOpen = false,
  });

  NodeEntity copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    NodeEntityStatus? status,
    bool? isOpen,
  }) {
    return NodeEntity(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      status: status ?? this.status,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  @override
  String toString() {
    return 'NodeEntity{id: $id, x: $x, y: $y, width: $width, height: $height, status: $status}';
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NodeEntity && runtimeType == other.runtimeType && id == other.id && x == other.x && y == other.y && width == other.width && height == other.height && status == other.status;

  @override
  int get hashCode => id.hashCode ^ x.hashCode ^ y.hashCode ^ width.hashCode ^ height.hashCode ^ status.hashCode;
}

enum NodeEntityStatus { start, end, path, wall}
