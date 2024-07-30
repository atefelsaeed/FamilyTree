import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';
import 'package:sulala/data/models/animal_model.dart';
import 'package:sulala/data/providers/animal_controller.dart';
import 'package:sulala/presentaion/home_screen/components/animal_item.dart';
import 'package:sulala/presentaion/home_screen/components/custom_edge_render.dart';
import 'package:sulala/presentaion/search_screen/search_animal.dart';
import 'package:sulala/utils/app_assets.dart';
import 'package:sulala/utils/enums.dart';

class FamilyTreeScreen extends StatefulWidget {
  const FamilyTreeScreen({super.key});

  @override
  _FamilyTreeScreenState createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
    ..siblingSeparation = (100)
    ..levelSeparation = (150)
    ..subtreeSeparation = (150)
    ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

  AnimalNode root = AnimalNode(
    id: '464478',
    name: 'Rocky',
    status: AnimalStatus.sold,
    image: AppAssets.defaultAnimal3,
    gender: AnimalGender.femail,
    children: [],
  );

  @override
  void initState() {
    super.initState();
    _buildGraph();
  }

  void _buildGraph() {
    graph.nodes.clear();
    Node rootNode = Node(_createNodeWidget(root));
    graph.addNode(rootNode);
    _addChildrenToGraph(root, rootNode);
  }

  void _addChildrenToGraph(AnimalNode parent, Node parentNode) {
    for (var child in parent.children) {
      Node childNode = Node(_createNodeWidget(child));
      graph.addEdge(parentNode, childNode);
      _addChildrenToGraph(child, childNode);
    }
  }

  Widget _createNodeWidget(AnimalNode node) {
    return Consumer<AnimalController>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () {
          provider.updateCurrentAnimalNode(node);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(
                callBack: () {
                  node.children.add(provider.state.selectedAnimalNode!);
                  _buildGraph();
                },
              ),
            ),
          );
        },
        child: AnimalItem(animalModel: node),
      );
    });
  }

  void _addNewNode(AnimalNode parentNode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Animal'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // AnimalNode newNode = AnimalNode(
                  //     id: idController.text,
                  //     name: nameController.text,
                  //     status: AnimalStatus.dead,
                  //     gender: AnimalGender.femail,
                  //     children: [],
                  //     image: AppAssets.defaultAnimal2);

                  // Rebuild the graph with the new node
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Tree'),
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(30),
        minScale: 0.01,
        maxScale: 5.6,
        child: GraphView(
          graph: graph,
          algorithm:
              BuchheimWalkerAlgorithm(builder, CustomEdgeRenderer(builder)),
          paint: Paint()
            ..color = Colors.green
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke,
          builder: (Node node) {
            var animalNode = node.key!.value as AnimalNode;
            return _createNodeWidget(animalNode);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewNode(
              root); // Assume root node is where we add new children; adjust as needed
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
