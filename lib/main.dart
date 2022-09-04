import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:audioplayers/audioplayers.dart' as audioPlayerPlugin;
import 'package:window_size/window_size.dart' as windowSizePlugin;

const List<List<String>> _terrainLayout = [
  ['b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b'],
  ['b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b'],
  ['b', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'p', 'b', 'p', 'b', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'p', 'p', 'p', 'b'],
  ['b', 'p', 'b', 'b', 'p', 'b', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'w', 'p', 'p', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b'],
  ['b', 'p', 'b', 'p', 'p', 'p', 'b', 'w', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'p', 'b', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b'],
  ['b', 'p', 'b', 'b', 'b', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'p', 'p', 'p', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'b'],
  ['b', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'p', 'b'],
  ['b', 'p', 'b', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'b'],
  ['b', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'b'],
  ['b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'p', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b'],
  ['b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'p', 'b'],
  ['b', 'p', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'p', 'b', 'p', 'b', 'b', 'p', 'p', 'p', 'b', 'b', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'p', 'p', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'p', 'p', 'b', 'p', 'p', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'p', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'b', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'p', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'p', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'p', 'p', 'b', 'b', 'b', 'w', 'w', 'w', 'b', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'b', 'p', 'b', 'p', 'b', 'b', 'w', 'w', 'w', 'w', 'w', 'w', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'p', 'p', 'p', 'b', 'p', 'p', 'w', 'w', 'w', 'w', 'w', 'w', 'w', 'w', 'w', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'b', 'b', 'p', 'b'],
  ['b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'c', 'b'],
];

const List<List<String>> _entityLayout = [
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', 'm', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', 'r', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'n', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 't', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'g', '_', '_', 'k', '_', '_', '_', '_', '_', 's', '_', '_'],
  ['_', 'a', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', 'c', '_', '_', '_', 'f', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'b', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'd', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', 'j', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'q', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 't', '_', '_', '_', 's', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', 'l', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', 'p', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'b', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', '_', 's', '_', '_', 'e', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', '_', '_', 'a', '_', '_', 'h', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'o', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_'],
  ['_', '_', 's', '_', '_', '_', '_', '_', '_', '_', '_', 'i', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 't', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 'o', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_', '_', 's', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', 's', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
  ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
];

const double _titleBarHeight = 50;
const double _sidebarWidth = 140;
const double _messagesPanelHeight = 50;

void main() async {
  final Size boardSize = Size.square(Tile.size * _terrainLayout.length);

  runZonedGuarded<void>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Size frameSize = boardSize + const Offset(_sidebarWidth, _titleBarHeight + _messagesPanelHeight);
    windowSizePlugin.setWindowFrame(Offset.zero & frameSize);
    windowSizePlugin.setWindowMaxSize(frameSize);
    windowSizePlugin.setWindowMinSize(frameSize);
    windowSizePlugin.setWindowTitle('Mini Maze Game');
    await Future.delayed(const Duration(milliseconds: 0));
  }, (Object error, StackTrace stack) {
    // Non-desktop platforms don't support window resize.
  });

  runApp(
    MiniMazeApp(
      character: Character(),
      boardSize: boardSize,
    ),
  );
}

class MiniMazeApp extends StatelessWidget {
  const MiniMazeApp({
    Key? key,
    required this.character,
    required this.boardSize,
  }) : super(key: key);

  final Character character;
  final Size boardSize;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(color: Color(0xff000000)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(BorderSide(width: 5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(height: boardSize.height),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Board(character: character, boardSize: boardSize),
                      Flexible(
                        fit: FlexFit.tight,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            border: Border(left: BorderSide(width: 5)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Sidebar(character: character),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Find your way to the end of the maze using up, '
                          'down, left, right arrow keys. If you encounter '
                          'enemies or obstacles, you may need to pick up tools '
                          'that can help clear your path. You can fill a '
                          'bucket up by going into water.'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Sidebar extends StatefulWidget {
  const Sidebar({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  void initState() {
    super.initState();
    widget.character.inventory.inventoryChangedHandler = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage("assets/images/large_axe_1.gif"), context);
    precacheImage(AssetImage("assets/images/large_axe_2.gif"), context);
    precacheImage(AssetImage("assets/images/large_axe_3.gif"), context);
    precacheImage(AssetImage("assets/images/large_bucket_1.gif"), context);
    precacheImage(AssetImage("assets/images/large_bucket_2.gif"), context);
    precacheImage(AssetImage("assets/images/large_pickaxe_1.gif"), context);
    precacheImage(AssetImage("assets/images/large_pickaxe_2.gif"), context);
    precacheImage(AssetImage("assets/images/large_pickaxe_3.gif"), context);
    precacheImage(AssetImage("assets/images/large_shovel_1.gif"), context);
    precacheImage(AssetImage("assets/images/large_sword_1.gif"), context);
    precacheImage(AssetImage("assets/images/large_sword_2.gif"), context);
  }

  @override
  void dispose() {
    widget.character.inventory.inventoryChangedHandler = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Inventory',
          textAlign: TextAlign.center,
          style: DefaultTextStyle.of(context).style.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        InventoryItem(tool: widget.character.inventory.axe),
        InventoryItem(tool: widget.character.inventory.pickaxe),
        InventoryItem(tool: widget.character.inventory.sword),
        InventoryItem(tool: widget.character.inventory.bucket),
        InventoryItem(tool: widget.character.inventory.shovel),
      ],
    );
  }
}

class InventoryItem extends StatelessWidget {
  const InventoryItem({
    Key? key,
    required this.tool,
  }) : super(key: key);

  final Tool? tool;

  @override
  Widget build(BuildContext context) {
    Widget? image;
    if (tool != null) {
      image = Image.asset('assets/images/large_${tool!.name}_${tool!.level}.gif', fit: BoxFit.contain);
    }
    return Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(child: image),
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.character,
    required this.boardSize,
  }) : super(key: key);

  final Character character;
  final Size boardSize;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late bool isMusicStarted;
  late FocusNode focusNode;
  late audioPlayerPlugin.AudioPlayer fx;
  late audioPlayerPlugin.AudioPlayer bgMusic;
  late List<List<Terrain>> terrain;
  late List<List<Entity>> entities;

  Widget _buildBoard(BuildContext context) {
    List<Widget> children = [];
    for (int col = 0; col < terrain.first.length; col++) {
      children.add(_buildColumn(context, col));
    }
    return Row(children: children);
  }

  Widget _buildColumn(BuildContext context, int col) {
    List<Widget> children = [];
    for (int row = 0; row < terrain.length; row++) {
      children.add(_buildTile(context, row, col));
    }
    return Column(children: children);
  }

  Widget _buildTile(BuildContext context, int row, int col) {
    Terrain terrainTile = terrain[row][col];
    Entity entityTile = entities[row][col];

    return SizedBox(
        width: Tile.size,
        height: Tile.size,
        child: ColoredBox(
          color: const Color.fromARGB(255, 255, 219, 174),
          child: DecoratedBox(
            decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(width: 1))),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Center(
                child: Stack(
                  children: [
                    terrainTile,
                    entityTile,
                    if (widget.character.isAt(row, col)) Avatar(),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
    if (kIsWeb && !isMusicStarted) {
      _startBgMusic();
    }
    if (event is KeyUpEvent) {
      return KeyEventResult.ignored;
    }

    int row = widget.character.row;
    int col = widget.character.col;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      row--;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      row++;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      col--;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      col++;
    }

    if (row != widget.character.row || col != widget.character.col) {
      Terrain newTerrain = terrain[row][col];
      if (newTerrain.acceptsCharacter(widget.character, fx)) {
        Entity newEntity = entities[row][col];
        if (newEntity.characterMovesOntoEntity(widget.character, fx)) {
          setState(() {
            entities[row][col] = const NoEntity();
            widget.character.row = row;
            widget.character.col = col;
          });
          if (newTerrain.isWinningMove()) {
            focusNode.unfocus();
          }
        }
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _startBgMusic() async {
    assert(!isMusicStarted);
    isMusicStarted = true;
    await bgMusic.setReleaseMode(audioPlayerPlugin.ReleaseMode.loop);
    await bgMusic.setVolume(0.6);
    return bgMusic.play(audioPlayerPlugin.AssetSource('sounds/background.mp3'));
  }

  @override
  void initState() {
    super.initState();
    isMusicStarted = false;
    focusNode = FocusNode();
    fx = audioPlayerPlugin.AudioPlayer();
    bgMusic = audioPlayerPlugin.AudioPlayer();
    if (!kIsWeb) {
      _startBgMusic();
    }
    terrain = _terrainLayout.map<List<Terrain>>((List<String> row) {
      return row.map<Terrain>((String value) => Terrain.fromValue(value)).toList();
    }).toList();
    entities = _entityLayout.map<List<Entity>>((List<String> row) {
      return row.map<Entity>((String value) => Entity.fromValue(value)).toList();
    }).toList();
  }

  @override
  void dispose() {
    focusNode.dispose();
    fx.dispose();
    bgMusic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boardSize.width,
      height: widget.boardSize.height,
      child: Focus(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: handleKeyEvent,
        child: _buildBoard(context),
      ),
    );
  }
}

class Character {
  final Inventory inventory = Inventory();
  int row = 1;
  int col = 1;

  bool isAt(int row, int col) => this.row == row && this.col == col;

  void pickUpTool(Tool tool) {
    tool.addToInventory(inventory);
  }

  void hitFire() {
    if (inventory.bucket != null) {
      inventory.bucket = Bucket(level: 1);
    }
  }
}

typedef InventoryChangedCallback = void Function();

class Inventory {
  InventoryChangedCallback? inventoryChangedHandler;
  Axe? _axe;
  Pickaxe? _pickaxe;
  Sword? _sword;
  Bucket? _bucket;
  Shovel? _shovel;

  void _notify() {
    if (inventoryChangedHandler != null) {
      inventoryChangedHandler!();
    }
  }

  Axe? get axe => _axe;
  set axe(Axe? axe) {
    _axe = axe;
    _notify();
  }

  int get axeLevel => axe?.level ?? 0;

  Pickaxe? get pickaxe => _pickaxe;
  set pickaxe(Pickaxe? pickaxe) {
    _pickaxe = pickaxe;
    _notify();
  }

  int get pickaxeLevel => pickaxe?.level ?? 0;

  Sword? get sword => _sword;
  set sword(Sword? sword) {
    _sword = sword;
    _notify();
  }

  int get swordLevel => sword?.level ?? 0;

  Bucket? get bucket => _bucket;
  set bucket(Bucket? bucket) {
    _bucket = bucket;
    _notify();
  }

  int get bucketLevel => bucket?.level ?? 0;

  Shovel? get shovel => _shovel;
  set shovel(Shovel? shovel) {
    _shovel = shovel;
    _notify();
  }

  int get shovelLevel => shovel?.level ?? 0;
}

@immutable
abstract class Tile extends StatelessWidget {
  static const double size = 24;

  const Tile();
}

class Avatar extends StatelessWidget {
  const Avatar();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/character.gif', width: 22, height: 20);
  }
}

abstract class Terrain extends Tile {
  const Terrain();

  factory Terrain.fromValue(String value) {
    switch (value) {
      case 'b':
        return const Bush();
      case 'w':
        return const Water();
      case 'c':
        return const Castle();
      case 'p':
        return const Path();
      default:
        throw ArgumentError();
    }
  }

  bool acceptsCharacter(Character character, audioPlayerPlugin.AudioPlayer fx);
  bool isWinningMove();
}

class Bush extends Terrain {
  const Bush();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/bush.gif', width: 22, height: 22);
  }

  @override
  bool acceptsCharacter(Character character, audioPlayerPlugin.AudioPlayer fx) => false;

  @override
  bool isWinningMove() => false;
}

class Path extends Terrain {
  const Path();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square();
  }

  @override
  bool acceptsCharacter(Character character, audioPlayerPlugin.AudioPlayer fx) => true;

  @override
  bool isWinningMove() => false;
}

class Water extends Terrain {
  const Water();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/water.gif', width: 22, height: 22);
  }

  @override
  bool acceptsCharacter(Character character, audioPlayerPlugin.AudioPlayer fx) {
    if (character.inventory.bucket?.level == 1) {
      character.inventory.bucket = Bucket(level: 2);
      fx.play(audioPlayerPlugin.AssetSource('sounds/water_hit.mp3'));
    }
    return false;
  }

  @override
  bool isWinningMove() => false;
}

class Castle extends Terrain {
  const Castle();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/castle.gif', width: 22, height: 22);
  }

  @override
  bool acceptsCharacter(Character character, audioPlayerPlugin.AudioPlayer fx) => true;

  @override
  bool isWinningMove() => true;
}

abstract class Entity extends Tile {
  const Entity();

  factory Entity.fromValue(String value) {
    switch (value) {
      case 'a':
        return const Enemy(level: 1);
      case 'b':
        return const Enemy(level: 2);
      case 'c':
        return const Axe(level: 1);
      case 'd':
        return const Axe(level: 2);
      case 'e':
        return const Axe(level: 3);
      case 'f':
        return const Pickaxe(level: 1);
      case 'g':
        return const Pickaxe(level: 2);
      case 'h':
        return const Pickaxe(level: 3);
      case 'i':
        return const Shovel(level: 1);
      case 'j':
        return const Sword(level: 1);
      case 'k':
        return const Sword(level: 2);
      case 'l':
        return const Bucket(level: 1);
      case 'm':
        return const Wood(level: 1);
      case 'n':
        return const Wood(level: 2);
      case 'o':
        return const Wood(level: 3);
      case 'p':
        return const Stone(level: 1);
      case 'q':
        return const Stone(level: 2);
      case 'r':
        return const Stone(level: 3);
      case 's':
        return const Fire(level: 2);
      case 't':
        return const Hole(level: 1);
      case '_':
        return const NoEntity();
      default:
        throw ArgumentError();
    }
  }

  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx);
}

class NoEntity extends Entity {
  const NoEntity();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square();
  }

  @override
  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx) => true;
}

abstract class Obstacle extends Entity {
  const Obstacle({required this.level});

  final int level;
}

class Hole extends Obstacle {
  const Hole({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/hole.gif', width: 16, height: 16);
  }

  @override
  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx) {
    if (level <= character.inventory.shovelLevel) {
      fx.play(audioPlayerPlugin.AssetSource('sounds/hole_pass.mp3'));
      return true;
    } else {
      fx.play(audioPlayerPlugin.AssetSource('sounds/hole_hit.mp3'));
      return false;
    }
  }
}

class Wood extends Obstacle {
  const Wood({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/wood_$level.gif', width: 22, height: 22);
  }

  @override
  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx) {
    if (level <= character.inventory.axeLevel) {
      fx.play(audioPlayerPlugin.AssetSource('sounds/wood_pass.mp3'));
      return true;
    } else {
      fx.play(audioPlayerPlugin.AssetSource('sounds/wood_hit.mp3'));
      return false;
    }
  }
}

class Fire extends Obstacle {
  const Fire({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/fire.gif', width: 12, height: 13);
  }

  @override
  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx) {
    if (level <= character.inventory.bucketLevel) {
      character.hitFire();
      fx.play(audioPlayerPlugin.AssetSource('sounds/fire_pass.mp3'));
      return true;
    } else {
      fx.play(audioPlayerPlugin.AssetSource('sounds/fire_hit.mp3'));
      return false;
    }
  }
}

class Stone extends Obstacle {
  const Stone({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/stone_$level.gif', width: 22, height: 22);
  }

  @override
  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx) {
    if (level <= character.inventory.pickaxeLevel) {
      fx.play(audioPlayerPlugin.AssetSource('sounds/stone_pass.mp3'));
      return true;
    } else {
      fx.play(audioPlayerPlugin.AssetSource('sounds/stone_hit.mp3'));
      return false;
    }
  }
}

class Enemy extends Entity {
  const Enemy({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/goblin_$level.gif', width: 18, height: 18);
  }

  @override
  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx) {
    if (level <= character.inventory.swordLevel) {
      fx.play(audioPlayerPlugin.AssetSource('sounds/enemy_pass.mp3'));
      return true;
    } else {
      fx.play(audioPlayerPlugin.AssetSource('sounds/enemy_hit.mp3'));
      return false;
    }
  }
}

abstract class Tool extends Entity {
  const Tool({required this.level});

  final int level;

  @override
  bool characterMovesOntoEntity(Character character, audioPlayerPlugin.AudioPlayer fx) {
    character.pickUpTool(this);
    fx.stop().then((_) {
      fx.play(audioPlayerPlugin.AssetSource('sounds/tool.mp3'));
    });
    return true;
  }

  String get name;
  void addToInventory(Inventory inventory);
}

class Shovel extends Tool {
  const Shovel({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/shovel_$level.gif', width: 13, height: 13);
  }

  @override
  void addToInventory(Inventory inventory) {
    if (inventory.shovelLevel < level) {
      inventory.shovel = this;
    }
  }

  @override
  String get name => 'shovel';
}

class Sword extends Tool {
  const Sword({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/sword_$level.gif', width: 16, height: 16);
  }

  @override
  void addToInventory(Inventory inventory) {
    if (inventory.swordLevel < level) {
      inventory.sword = this;
    }
  }

  @override
  String get name => 'sword';
}

class Bucket extends Tool {
  const Bucket({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/bucket_$level.gif', width: 12, height: 13);
  }

  @override
  void addToInventory(Inventory inventory) {
    if (inventory.bucketLevel < level) {
      inventory.bucket = this;
    }
  }

  @override
  String get name => 'bucket';
}

class Pickaxe extends Tool {
  const Pickaxe({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/pickaxe_$level.gif', width: 13, height: 13);
  }

  @override
  void addToInventory(Inventory inventory) {
    if(inventory.pickaxeLevel < level) {
      inventory.pickaxe = this;
    }
  }

  @override
  String get name => 'pickaxe';
}

class Axe extends Tool {
  const Axe({required int level}) : super(level: level);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/axe_$level.gif', width: 12, height: 14);
  }

  @override
  void addToInventory(Inventory inventory) {
    if (inventory.axeLevel < level) {
      inventory.axe = this;
    }
  }

  @override
  String get name => 'axe';
}
