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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PageView()));
          },
          // child: Image(image: AssetImage('lib/assets/card_back01.png'))),
          child: const Text('meow'),
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20.0)),
        ),
      ),
    );
  }
}

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
