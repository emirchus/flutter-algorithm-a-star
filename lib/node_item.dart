import 'package:flutter/material.dart';
import 'package:start_algorithm/entity/node_entity.dart';

class NodeItem extends StatelessWidget {
  final NodeEntity node;

  final VoidCallback onTap;

  const NodeItem({super.key, required this.node, required this.onTap});

  Color colorByType() {
    if (node.isOpen && node.status == NodeEntityStatus.path) return Colors.white;
    switch (node.status) {
      case NodeEntityStatus.start:
        return Colors.blueAccent[100]!;
      case NodeEntityStatus.end:
        return Colors.orangeAccent[100]!;
      case NodeEntityStatus.wall:
        return Colors.deepPurpleAccent[100]!;
      case NodeEntityStatus.path:
      default:
        return Colors.white30;
    }
  }

  String textByType() {
    switch (node.status) {
      case NodeEntityStatus.start:
        return 'Start';
      case NodeEntityStatus.end:
        return 'End';
      case NodeEntityStatus.wall:
      case NodeEntityStatus.path:
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: node.width - 8,
          height: node.height - 8,
          decoration: BoxDecoration(
            color: colorByType(),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              textByType(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
