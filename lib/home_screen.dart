import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:start_algorithm/entity/movement_entity.dart';
import 'package:start_algorithm/entity/node_entity.dart';
import 'package:start_algorithm/node_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<NodeEntity> _nodes = [];

  final Map<int, MovementEntity> _openList = {};
  final List<NodeEntity> _closedList = [];

  NodeEntity? _currentMovement;

  int? startId, endId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startGrid();
    });
    super.initState();
  }

  void startGrid() {
    _nodes.clear();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final nodeWidth = width / 10;
    final nodeHeight = height / 10;
    for (var i = 0; i < 10; i++) {
      for (var j = 0; j < 10; j++) {
        _nodes.add(NodeEntity(
          id: i * 10 + j,
          x: i * nodeWidth,
          y: j * nodeHeight,
          width: nodeWidth,
          height: nodeHeight,
        ));
      }
    }
    setState(() {});
  }

  void pathFinder() {
    NodeEntity startNode = _nodes[startId!];
    NodeEntity endNode = _nodes[endId!];
    _closedList.clear();
    _openList.clear();

    for (var element in _nodes) {
      element.isOpen = false;
    }

    _closedList.add(startNode);

    List<NodeEntity> neighbors = getNeighbors(startNode);

    print(startNode);

    neighbors.forEachIndexed((index, element) {
      bool isDiagonal = (element.x - startNode.x).abs() == (element.y - startNode.y).abs();

      final movementCost = isDiagonal ? 14 : 10;

      final heuristicCost = sqrt(pow(element.x - endNode.x, 2) + pow(element.y - endNode.y, 2));

      _openList[element.id] = MovementEntity(
        node: element,
        parent: startNode,
        heuristicCost: heuristicCost,
        movementCost: movementCost,
        totalCost: movementCost + heuristicCost,
      );

      setState(() {});
    });

    final openList = _openList.values.toList()..sort((a, b) => a.totalCost.compareTo(b.totalCost));

    _currentMovement = openList.first.node;

    _nodes[_currentMovement!.id] = _currentMovement!.copyWith(isOpen: true);

    _openList.remove(_currentMovement!.id);

    setState(() {});

    calculateNextMovement();
  }

  List<NodeEntity> getNeighbors(NodeEntity entity) {
    List<NodeEntity> neighbors = [];

    final x = entity.x / entity.width;
    final y = entity.y / entity.height;

    final left = x - 1;
    final right = x + 1;
    final top = y - 1;
    final bottom = y + 1;

    if (left >= 0) {
      final leftNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == left && element.y ~/ element.height == y);
      if (leftNode != null && leftNode.status != NodeEntityStatus.wall && !_closedList.contains(leftNode)) neighbors.add(leftNode);
    }

    if (right < 10) {
      final rightNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == right && element.y ~/ element.height == y);
      if (rightNode != null && rightNode.status != NodeEntityStatus.wall && !_closedList.contains(rightNode)) neighbors.add(rightNode);
    }

    if (top >= 0) {
      final topNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == x && element.y ~/ element.height == top);
      if (topNode != null && topNode.status != NodeEntityStatus.wall && !_closedList.contains(topNode)) neighbors.add(topNode);
    }

    if (bottom < 10) {
      final bottomNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == x && element.y ~/ element.height == bottom);
      if (bottomNode != null && bottomNode.status != NodeEntityStatus.wall && !_closedList.contains(bottomNode)) neighbors.add(bottomNode);
    }

    if (left >= 0 && top >= 0) {
      final topLeftNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == left && element.y ~/ element.height == top);

      final topNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == x && element.y ~/ element.height == top);
      final leftNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == left && element.y ~/ element.height == y);

      if (topLeftNode != null && topLeftNode.status != NodeEntityStatus.wall && !_closedList.contains(topLeftNode) && topNode!.status != NodeEntityStatus.wall && leftNode!.status != NodeEntityStatus.wall) neighbors.add(topLeftNode);
    }

    if (right < 10 && top >= 0) {
      final topRightNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == right && element.y ~/ element.height == top);

      final topNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == x && element.y ~/ element.height == top);
      final rightNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == right && element.y ~/ element.height == y);

      bool isValidTopNode = topNode == null || topNode.status != NodeEntityStatus.wall;
      bool isValidRightNode = rightNode == null || rightNode.status != NodeEntityStatus.wall;

      if (topRightNode != null && topRightNode.status != NodeEntityStatus.wall && !_closedList.contains(topRightNode) && isValidTopNode && isValidRightNode) neighbors.add(topRightNode);
    }

    if (left >= 0 && bottom < 10) {
      final bottomLeftNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == left && element.y ~/ element.height == bottom);

      final bottomNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == x && element.y ~/ element.height == bottom);
      final leftNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == left && element.y ~/ element.height == y);

      bool isValidBottomNode = bottomNode == null || bottomNode.status != NodeEntityStatus.wall;
      bool isValidLeftNode = leftNode == null || leftNode.status != NodeEntityStatus.wall;

      if (bottomLeftNode != null && bottomLeftNode.status != NodeEntityStatus.wall && !_closedList.contains(bottomLeftNode) && isValidBottomNode && isValidLeftNode) neighbors.add(bottomLeftNode);
    }

    if (right < 10 && bottom < 10) {
      final bottomRightNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == right && element.y ~/ element.height == bottom);

      final bottomNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == x && element.y ~/ element.height == bottom);
      final rightNode = _nodes.firstWhereOrNull((element) => element.x ~/ element.width == right && element.y ~/ element.height == y);

      bool isValidBottomNode = bottomNode == null || bottomNode.status != NodeEntityStatus.wall;
      bool isValidRightNode = rightNode == null || rightNode.status != NodeEntityStatus.wall;

      if (bottomRightNode != null && bottomRightNode.status != NodeEntityStatus.wall && !_closedList.contains(bottomRightNode) && isValidBottomNode && isValidRightNode) neighbors.add(bottomRightNode);
    }

    return neighbors;
  }

  void calculateNextMovement() {
    final currentNode = _currentMovement;
    final endNode = _nodes[endId!];

    if (currentNode == null) return;

    if (currentNode.id == endNode.id) {
      print("Found");
      return;
    }

    List<NodeEntity> neighbors = getNeighbors(currentNode);

    neighbors.forEachIndexed((index, element) {
      bool isDiagonal = (element.x - currentNode.x).abs() == (element.y - currentNode.y).abs();

      final movementCost = isDiagonal ? 14 : 10;

      final heuristicCost = sqrt(pow(element.x - endNode.x, 2) + pow(element.y - endNode.y, 2));

      final MovementEntity? movementEntity = _openList[element.id];

      if (movementEntity != null) {
        if (movementEntity.movementCost + movementEntity.heuristicCost < movementCost + heuristicCost) {
          return;
        }
      }

      _openList[element.id] = MovementEntity(
        node: element,
        parent: currentNode,
        heuristicCost: heuristicCost,
        movementCost: movementCost,
        totalCost: movementCost + heuristicCost,
      );

      setState(() {});
    });

    final openList = _openList.values.toList()..sort((a, b) => a.totalCost.compareTo(b.totalCost));

    _currentMovement = openList.first.node;


    _openList.remove(_currentMovement!.id);

    _closedList.add(currentNode);

    _nodes[_currentMovement!.id] = _currentMovement!.copyWith(isOpen: true);
    setState(() {});

    Future.delayed(const Duration(milliseconds: 100), () {
      calculateNextMovement();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (startId != null && endId != null) pathFinder();
        },
        child: const Icon(Icons.play_arrow),
      ),
      backgroundColor: const Color(0xFF000000),
      body: SizedBox.fromSize(
        size: size,
        child: Stack(
          children: [
            ..._nodes.mapIndexed<Widget>((i, node) {
              return Positioned(
                left: node.x - 4,
                top: node.y - 4,
                child: NodeItem(
                  node: node,
                  onTap: () {
                    int currentStatusIndex = NodeEntityStatus.values.indexOf(node.status);

                    List<int> statusIndexes = [
                      0,
                      1,
                      2,
                      3,
                    ];

                    int indexed = statusIndexes[(currentStatusIndex + 1) % statusIndexes.length];

                    if (startId != null && startId != node.id) statusIndexes.remove(0);
                    if (endId != null && endId != node.id) statusIndexes.remove(1);

                    currentStatusIndex = statusIndexes[(indexed) % statusIndexes.length];

                    if (currentStatusIndex == 0) startId = node.id;
                    if (currentStatusIndex == 1) endId = node.id;

                    if (currentStatusIndex != 0 && startId == node.id) startId = null;
                    if (currentStatusIndex != 1 && endId == node.id) endId = null;

                    setState(() {
                      _nodes[node.id] = node.copyWith(status: NodeEntityStatus.values[currentStatusIndex]);
                    });
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
