import 'package:flutter/material.dart';

// A flash card image
class FlashCard {
  final Image cardBack;
  final Image cardFace;

  FlashCard(this.cardBack, this.cardFace);

  // Stack the card face onto the background
  Container show() {
    return Container(
      child: Stack(
        children: <Widget>[
          cardBack,
          cardFace,
        ],
      ),
    );
  }
}

// Represents the deck of flash cards.. ABC's for now
// Hard Coding stuff for now, fix later
class CardDeck {
  List<FlashCard> deck = [];
  late int topInd;
  late int nextInd;
  late int prevInd;

  CardDeck() {
    deck = [
      FlashCard(Image(image: AssetImage('lib/assets/card_back01.png')),
          Image(image: AssetImage('lib/assets/letter_a.png'))),
      FlashCard(Image(image: AssetImage('lib/assets/card_back01.png')),
          Image(image: AssetImage('lib/assets/letter_b.png'))),
      FlashCard(Image(image: AssetImage('lib/assets/card_back01.png')),
          Image(image: AssetImage('lib/assets/letter_c.png')))
    ];
    this.topInd = 0;
    // this.nextInd = 1;
    // this.prevInd = 2;
  }

  FlashCard top() {
    FlashCard c = deck.elementAt(topInd);
    return c;
  }

  FlashCard next() {
    this.topInd = ++this.topInd % 3;
    // this.nextInd = ++this.nextInd % 3;
    // this.prevInd = ++this.prevInd % 3;

    return top();
  }

  FlashCard prev() {
    this.topInd = --this.topInd % 3;
    // this.nextInd = --this.nextInd % 3;
    // this.prevInd = --this.prevInd % 3;

    return top();
  }
}
