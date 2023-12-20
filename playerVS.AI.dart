import 'dart:io';
import 'dart:math';

bool win = false;
bool xTurn = true;
int moveCounter = 0;
List<String> values = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

String playerMarker = 'X';
String aiMarker = 'O';

void main() {
  print("Welcome to Tic Tac Toe!");
  chooseMarkers();
  while (true) {
    generateBoard();
    if (xTurn) {
      getChar();
    } else {
      aiMove();
    }
    if (win || moveCounter == 9) {
      print("Do you want to play again? (yes/no)");
      String playAgain = stdin.readLineSync()?.toLowerCase() ?? "";
      if (playAgain != "yes") {
        print("Thanks for playing! Goodbye.");
        break;
      } else {
        resetGame();
        chooseMarkers();
      }
    }
  }
}

void chooseMarkers() {
  print("Player 1, choose your marker ('X' or 'O'):");
  String choice = stdin.readLineSync()?.toUpperCase() ?? "";
  if (choice == 'O') {
    playerMarker = 'O';
    aiMarker = 'X';
    xTurn = false;
  }
  print(
      "Player 1 is '$playerMarker', and the AI is '$aiMarker'. Let's begin!\n");
}

void generateBoard() {
  print('===========');
  for (int i = 0; i < 7; i += 3) {
    print(' ${values[i]} | ${values[i + 1]} | ${values[i + 2]}');
    if (i != 6) {
      print('---+---+---');
    }
  }
  print('===========');
}

void getChar() {
  String whoTurn = xTurn ? playerMarker : aiMarker;
  print('Your turn ${whoTurn}, choose number...');

  int number;
  while (true) {
    String input = stdin.readLineSync()!;
    try {
      number = int.parse(input);
      if (number >= 1 && number <= 9) {
        if (values[number - 1] == 'X' || values[number - 1] == 'O') {
          print('This place has been filled before, choose another number');
        } else
          break;
      } else {
        print('You must enter a number in this range => [1, 9]');
      }
    } catch (err) {
      print('Invalid input. Please enter a valid integer.');
    }
  }

  values[number - 1] = whoTurn;
  moveCounter++;
  xTurn = !xTurn;

  if (checkForWin(whoTurn)) {
    win = true;
    generateBoard();
    print('Player ${whoTurn == playerMarker ? "1" : "AI"} wins!');
  } else if (moveCounter == 9) {
    generateBoard();
    print('It\'s a draw!');
  }
}

void aiMove() {
  print('AI\'s turn...');

  List<int> availableSpots = [];
  for (int i = 0; i < values.length; i++) {
    if (values[i] != 'X' && values[i] != 'O') {
      availableSpots.add(i);
    }
  }

  if (availableSpots.isNotEmpty) {
    int aiChoice = availableSpots[Random().nextInt(availableSpots.length)];
    values[aiChoice] = aiMarker;
    moveCounter++;
    xTurn = !xTurn;

    if (checkForWin(aiMarker)) {
      win = true;
      generateBoard();
      print('You lose, try again');
    } else if (moveCounter == 9) {
      generateBoard();
      print('It\'s a draw!');
    }
  }
}

bool checkForWin(String player) {
  //check every row if has 3 X or 3 O according to player
  for (int i = 0; i < 7; i += 3) {
    if (values[i] == player &&
        values[i + 1] == player &&
        values[i + 2] == player) return true;
  }

  //check every column if has 3 X or 3 O according to player
  for (int i = 0; i < 3; i++) {
    if (values[i] == player &&
        values[i + 3] == player &&
        values[i + 6] == player) return true;
  }

  //check diagonal(\) if has 3 X or 3 O according to player
  if (values[0] == player && values[4] == player && values[8] == player)
    return true;

  //check diagonal(/) if has 3 X or 3 O according to player
  if (values[2] == player && values[4] == player && values[6] == player)
    return true;

  return false;
}

void resetGame() {
  win = false;
  xTurn = true;
  moveCounter = 0;
  values = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
}
