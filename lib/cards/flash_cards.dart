import 'package:flutter/material.dart';
import 'dart:io';

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
    this.topInd = 0;
    // this.nextInd = 1;
    // this.prevInd = 2;

    // Image loading stuff
    String assetsPath = "lib/assets/";

    Image cardBack = Image.asset(
      assetsPath + 'card_back01.png',
      // fit: BoxFit.fill,
      // width: double.infinity,
    );

    // Below is for auto loading the images, will fix it when I figure out
    // how to use this on andriod... Currently works for windows.

    // // Get the directory of the project, and append the assets folder to it.
    // String currentDir = Directory.current.toString();
    // // Directory.toString appends the text "Directory = '...'" before the path.
    // currentDir = currentDir.substring(12, currentDir.length - 1);
    // Directory dir = Directory(currentDir + '/' + assetsPath);

    // print(assetsPath);
    // print(currentDir);

    // List<FileSystemEntity> files = dir.listSync(recursive: false);
    // for (FileSystemEntity file in files) {
    //   FileStat f = file.statSync();

    //   String fileName = file.absolute.toString();
    //   fileName = fileName.split('/').last;
    //   if (fileName.contains('letter_')) {
    //     fileName = fileName.substring(0, fileName.length - 1);
    //     deck.add(FlashCard(
    //         cardBack,
    //         Image(
    //           image: AssetImage(assetsPath + fileName),
    //         )));
    //   }
    // }

    // This works until I can fix the above for android
    List<String> suffix = ["a", "b", "c"];

    for (String letter in suffix) {
      deck.add(FlashCard(
          cardBack,
          Image(
            image: AssetImage(assetsPath + 'letter_' + letter + '.png'),
          )));
    }
  }

  FlashCard top() {
    return deck.elementAt(topInd);
  }

  FlashCard next() {
    this.topInd = ++this.topInd % deck.length;
    // this.nextInd = ++this.nextInd % 3;
    // this.prevInd = ++this.prevInd % 3;

    return top();
  }

  FlashCard prev() {
    this.topInd = --this.topInd % deck.length;
    // this.nextInd = --this.nextInd % 3;
    // this.prevInd = --this.prevInd % 3;

    return top();
  }
}
