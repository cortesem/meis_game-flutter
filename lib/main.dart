import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'flash_cards.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mei\'s Game',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: HomeView(),
    );
  }
}

//
// Main App Page
//
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Center(child: const Text('Mei\'s Game')),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            // Animated route
            Navigator.of(context).push(_createRoute());
          },
          child: Image(
            image: AssetImage('lib/assets/a-z_icon.png'),
          ),
        ),
      ),
    );
  }

  // Transition from HomeView to ABC card page (PageView)
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PageView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}

//
// Flash Card Page, temp name..
//
class PageView extends StatefulWidget {
  @override
  _PageViewState createState() => _PageViewState();
}

class _PageViewState extends State<PageView> {
  CardDeck deck = CardDeck();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      // This is a little buggy due to having both draggable and dismissible at the same time,
      // however the behaviour is generally good.
      body: Stack(
        children: <Widget>[
          // Bottom Card
          DraggableFlashCard(
            child: deck.next().show(),
            // This fixes the card swapping bug, but does not fix the underlying issue
            // key: UniqueKey(),
          ),
          // Top card -> dismissible
          Dismissible(
            key: UniqueKey(),
            // movementDuration: Duration(milliseconds: 100),
            onDismissed: (direction) {
              setState(() {
                deck.next();
              });
            },
            child: DraggableFlashCard(
              child: deck.prev().show(),
              key: UniqueKey(),
            ),
          )
        ],
      ),
    );
  }
}

//
// Draggable flash card
//
class DraggableFlashCard extends StatefulWidget {
  const DraggableFlashCard({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  _DraggableFlashCardState createState() => _DraggableFlashCardState();
}

class _DraggableFlashCardState extends State<DraggableFlashCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}
