import 'package:flutter/material.dart';
import 'cards/flash_cards.dart';

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

// Main App Page
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Mei\'s Game')),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(_createRoute());
            // context, MaterialPageRoute(builder: (context) => PageView()));
          },
          // child: Image(image: AssetImage('lib/assets/card_back01.png'))),
          child: const Text('meow'),
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20.0)),
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

// Flash Card Page, temp name..
class PageView extends StatefulWidget {
  @override
  _PageViewState createState() => _PageViewState();
}

class _PageViewState extends State<PageView> {
  CardDeck deck = CardDeck();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            // onTap: () {
            //   setState(() {
            //     deck.next();
            //   });
            // },
            onHorizontalDragEnd: (details) {
              setState(() {
                if (details.primaryVelocity == null) return;
                if (details.primaryVelocity! > 0) {
                  deck.prev();
                }
                if (details.primaryVelocity! < 0) {
                  deck.next();
                }
              });
            },
            child: deck.top().show()),
      ),
    );
  }
}
