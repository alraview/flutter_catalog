import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class GraphViewExample extends StatefulWidget {
  const GraphViewExample({Key key}) : super(key: key);

  @override
  _GraphViewExampleState createState() => _GraphViewExampleState();
}

class _GraphViewExampleState extends State<GraphViewExample> {
  int _iterations = 1000;

  @override
  Widget build(BuildContext context) {
    // !! Step1: build the graph to render
    final Graph graph = Graph();
    // ! Create nodes
    final nodes = <Node>[
      for (int i = 0; i < 8; ++i)
        // The node can be any widget.
        Node(Chip(
          label: Text('node$i'),
          backgroundColor: Colors.primaries[i * 2][100],
        )),
    ];
    graph.addNodes(nodes);
    // ! Add edges to the graph
    graph.addEdge(nodes[0], nodes[1]);
    graph.addEdge(nodes[2], nodes[3]);
    graph.addEdge(nodes[1], nodes[4]);
    graph.addEdge(nodes[3], nodes[1]);
    graph.addEdge(nodes[4], nodes[0]);
    graph.addEdge(nodes[5], nodes[7]);
    graph.addEdge(
      nodes[4],
      nodes[2],
      // ! Custom edge style by providing the [paint] argument
      paint: Paint()
        ..color = Colors.red
        ..strokeWidth = 4,
    );

    final algo = FruchtermanReingoldAlgorithm(iterations: this._iterations)
      ..rand = Random(/*seed=*/ 0) // For deterministic rendering:
      ..attractionK = 100;

    return Scaffold(
      body: InteractiveViewer(
        constrained: false,
        scaleEnabled: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.1,
        maxScale: 5,
        child: GraphView(
            graph: graph,
            // ! There are other algorithms for other graphs:
            // * [SugiyamaAlgorithm] for layered graph
            // * [BuchheimWalkerAlgorithm] for tree graph
            // * [FruchtermanReingoldAlgorithm] for directed graph (this example)
            algorithm: algo),
      ),
      bottomNavigationBar: _buildControlWidgets(),
    );
  }

  Widget _buildControlWidgets() {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: ListView(
        children: [
          ListTile(title: Text('Iterations: $_iterations')),
          Slider(
            divisions: 100,
            max: 10000,
            onChanged: (double val) =>
                setState(() => this._iterations = val.toInt()),
            value: this._iterations.toDouble(),
            label: '${this._iterations}',
          ),
        ],
      ),
    );
  }
}
