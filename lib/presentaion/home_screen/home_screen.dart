import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:sulala/presentaion/home_screen/components/animal_item.dart';
import 'package:sulala/data/models/animal_model.dart';
import 'package:sulala/presentaion/search_screen/search_animal.dart';
import 'package:sulala/utils/app_assets.dart';
import 'package:sulala/utils/enums.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  _TreeViewPageState createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  final Graph graph = Graph()..isTree = true;

  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  Random r = Random();
  @override
  void initState() {
    final node1 = Node.Id(1);
    final node2 = Node.Id(2);
    print("node1 $node1");
    print("node12 $node2");
    graph.addEdge(node1, node2);

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Harry’s Family Tree"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SearchScreen(),
                  //   ),
                  // );
                  final node12 = Node.Id(r.nextInt(100));
                  var edge =
                      graph.getNodeAtPosition(r.nextInt(graph.nodeCount()));

                  print("Add New Edge!!!");
                  print(edge);
                  print(node12);
                  graph.addEdge(edge, node12);

                  setState(() {});
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(
                      Icons.add,
                      size: 35,
                    )),
              ),
            ),

            AnimalItem(
            animalModel: AnimalNode(
            id: '137656',
            name: 'Rocky',
            status: AnimalStatus.sold,
            image: AppAssets.defaultAnimal,
            gender: AnimalGender.mail,
              children: []
            ),
            ),

            graph.nodes.isEmpty
                ? Container()
                : Expanded(
                    child: InteractiveViewer(
                      // constrained: false,
                      minScale: 0.35,
                      maxScale: 1,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      child: OverflowBox(
                        alignment: Alignment.center,
                        minWidth: 0.0,
                        minHeight: 0.0,
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: GraphView(
                          graph: graph,
                          algorithm: BuchheimWalkerAlgorithm(
                              builder, TreeEdgeRenderer(builder)),
                          paint: Paint()
                            ..color = Colors.green
                            ..strokeWidth = 1
                            ..style = PaintingStyle.stroke,
                          builder: (Node node) {
                            // I can decide what widget should be shown here based on the id
                            var a = node.key!.value as int?;
                            return rectangleWidget(a);
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }

  Widget rectangleWidget(int? a) {
    return AnimalItem(
      animalModel: AnimalNode(
        id: '137656',
        name: 'Rocky',
        status: AnimalStatus.sold,
        image: AppAssets.defaultAnimal,
        gender: AnimalGender.mail,
        children: [],
      ),
    );
  }
}
