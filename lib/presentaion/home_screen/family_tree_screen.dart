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
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerRootNode();
    });
    _buildGraph();
  }

  void _centerRootNode() {
    Size size = MediaQuery.of(context).size;
    _transformationController.value = Matrix4.identity()
      ..translate(size.width / 2 - 50,
          size.height / 4 - 50); // Adjust the values to fit your graph
  }

  void _buildGraph() {
    graph.nodes.clear();
    Set<String> visitedNodes = {};
    Node rootNode = Node(_createNodeWidget(root));
    graph.addNode(rootNode);
    _addChildrenToGraph(root, rootNode, visitedNodes);
  }

  void _addChildrenToGraph(
      AnimalNode parent, Node parentNode, Set<String> visitedNodes) {
    if (visitedNodes.contains(parent.id)) {
      return; // Avoid circular reference
    }
    visitedNodes.add(parent.id);

    for (var child in parent.children) {
      Node childNode = Node(_createNodeWidget(child));
      graph.addEdge(parentNode, childNode);
      _addChildrenToGraph(child, childNode, visitedNodes);
    }

    // Add a placeholder node for adding new children
    Node addNode = Node(_createAddNodeWidget(parent));
    graph.addEdge(parentNode, addNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry\'s Family Tree'),
        centerTitle: true,
      ),
      body: Consumer<AnimalController>(builder: (context, provider, child) {
        return InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(50),
          minScale: 0.01,
          maxScale: 5.6,
          transformationController: _transformationController,
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
        );
      }),
    );
  }

  Widget _createAddNodeWidget(AnimalNode parent) {
    return Consumer<AnimalController>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () {
          provider.updateCurrentAnimalNode(parent);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(
                callBack: () {
                  AnimalNode newNode = AnimalNode(
                    id: provider.state.selectedAnimalNode!.id,
                    name: provider.state.selectedAnimalNode!.name,
                    status: provider.state.selectedAnimalNode!.status,
                    gender: provider.state.selectedAnimalNode!.gender,
                    children: provider.state.selectedAnimalNode?.children ?? [],
                    image: provider.state.selectedAnimalNode!.image,
                  );

                  debugPrint(
                      "newNode : ${provider.state.selectedAnimalNode!.name}");

                  parent.children.add(newNode);
                  _buildGraph();
                },
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            // border: Border.all(color: Colors.green, width: 2),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 35,
          ),
        ),
      );
    });
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
                  AnimalNode newNode = AnimalNode(
                      id: provider.state.selectedAnimalNode!.id,
                      name: provider.state.selectedAnimalNode!.name,
                      status: provider.state.selectedAnimalNode!.status,
                      gender: provider.state.selectedAnimalNode!.gender,
                      children:
                          provider.state.selectedAnimalNode?.children ?? [],
                      image: provider.state.selectedAnimalNode!.image);

                  debugPrint(
                      "newNode : ${provider.state.selectedAnimalNode!.name}");

                  node.children.add(newNode);
                  _buildGraph();
                },
              ),
            ),
          );
        },
        child: AnimalItem(animalModel: node, key: ValueKey(node.id)),
      );
    });
  }
}
