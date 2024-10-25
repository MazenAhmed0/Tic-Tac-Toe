import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  int? choice;

  // Repeat until valid input is received
  while (choice == null) {
    print("Choose game mode:");
    print("1 - Two Players");
    print("2 - Play Against Computer (Easy)");
    print("3 - Play Against Computer (Hard)");
    stdout.write("Your choice: ");

    // Try to parse user input
    try {
      choice = int.parse(stdin.readLineSync()!);
    } catch (e) {
      print("Invalid input. Please enter a number.");
    }
  }

  // Proceed with valid choice
  if (choice == 1) {
    twoPlayerMode();
  } else if (choice == 2) {
    computerMode(easy: true); // Easy mode
  } else if (choice == 3) {
    computerMode(easy: false); // Hard mode
  } else {
    print("Invalid choice!");
    return; // Exit the program if invalid choice
  }

  // Ask user if they want to play again
  String? uInput;
  while (uInput == null) {
    stdout.write(
        "Do you want to play again? { y or 1 } for YES, anything else for NO: ");
    uInput = stdin.readLineSync();

    // Check if the user wants to play again
    if (uInput == "y" || uInput == "1") {
      main(args); // Restart the game
    } else {
      print("Goodbye!");
      exit(0); // Exit the program
    }
  }
}

// Drawing tha main bord
void drawingBoard(List<List<String>> board) {
  print("---------------");
  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[i].length; j++) {
      stdout.write("| " + board[i][j] + " |");
    }
    print("\n---------------");
  }
}

// check if these strings equal each other
bool equal(String x, String y, String z) {
  return (x == y && x == z);
}

// all posibilitis for check winner
int checkWinner(List<List<String>> board) {
  // X winner : 2
  // O winner : -2
  // tie : 0
  // no winner : 1
  int winner = 1;

  // for Cols
  for (int i = 0; i < 3; i++) {
    if (equal(board[0][i], board[1][i], board[2][i])) {
      winner = (board[0][i] == "X") ? 2 : -2;
      return winner;
    }
  }

  // for Rows
  for (int i = 0; i < 3; i++) {
    if (equal(board[i][0], board[i][1], board[i][2])) {
      winner = (board[i][0] == "X") ? 2 : -2;
      return winner;
    }
  }

  // for Diagonals
  if (equal(board[0][0], board[1][1], board[2][2])) {
    winner = (board[0][0] == "X") ? 2 : -2;
    return winner;
  }
  if (equal(board[0][2], board[1][1], board[2][0])) {
    winner = (board[0][2] == "X") ? 2 : -2;
    return winner;
  }

  // Check for a tie
  bool tie = true;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] != "X" && board[i][j] != "O" && winner == 1) {
        tie = false;
        break;
      }
    }
  }

  return (tie) ? 0 : 1;
}

// Two Player Mode
void twoPlayerMode() {
  List<List<String>> board = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9']
  ];
  bool has_winner = false;
  String player = "X";

  while (!has_winner) {
    drawingBoard(board);
    int? input;

    // Repeat until valid input is received
    while (input == null) {
      stdout.write("Player $player, where do you want to play: ");

      // Try to parse the input
      try {
        input = int.parse(stdin.readLineSync()!);
      } catch (e) {
        print("Invalid input. Please enter a valid number between 1 and 9.");
      }

      // Check if the input is within valid range
      if (input != null && (input < 1 || input > 9)) {
        print("Invalid choice. Please choose a number between 1 and 9.");
        input = null; // Reset input to re-prompt the user
      }
    }

    // Switch player after valid move
    if (updateBoard(board, input, player)) {
      player = (player == "X") ? "O" : "X";
    }

    // Check for a winner
    int result = checkWinner(board);
    if (result != 1) {
      has_winner = true;
      drawingBoard(board);
      if (result == 0) {
        print("It's a tie!");
      } else {
        print((result == 2 ? "X" : "O") + " is the winner!");
      }
    }
  }
}

// mini max to return
int minimax(List<List<String>> board, bool isMaximizing) {
  int result = checkWinner(board);
  if (result != 1) {
    return result;
  }

  if (isMaximizing) {
    int finalScore = -111;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] != "X" && board[i][j] != "O") {
          String original = board[i][j];
          board[i][j] = "X";
          int score = minimax(board, false);
          board[i][j] = original;
          finalScore = max(finalScore, score);
        }
      }
    }
    return finalScore;
  } else {
    int finalScore = 111;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] != "X" && board[i][j] != "O") {
          String original = board[i][j];
          board[i][j] = "O";
          int score = minimax(board, true);
          board[i][j] = original;
          finalScore = min(finalScore, score);
        }
      }
    }
    return finalScore;
  }
}

// Computer Mode (Easy or Hard)
void computerMode({required bool easy}) {
  List<List<String>> board = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9']
  ];
  bool has_winner = false;
  String player = "X";

  while (!has_winner) {
    drawingBoard(board);

    if (player == "X") {
      int? input;

      // Loop until valid input is received
      while (input == null) {
        stdout.write("Player $player, Where do you want to play: ");
        try {
          input = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Invalid input. Please enter a valid number between 1 and 9.");
        }

        // Ensure the input is between 1 and 9 and corresponds to an empty spot
        if (input != null &&
            (input < 1 || input > 9 || !updateBoard(board, input, player))) {
          print("Invalid move. Please try again.");
          input = null; // Reset input to re-prompt the player
        }
      }

      // After a valid move, switch to computer
      player = "O";
    } else {
      // Computer's turn
      print("Computer's Turn...");
      if (easy) {
        easyComputerMove(board);
      } else {
        hardComputerMove(board);
      }
      player = "X"; // Switch back to player
    }

    // Check for a winner
    int result = checkWinner(board);
    if (result != 1) {
      has_winner = true;
      drawingBoard(board);
      if (result == 0) {
        print("It's a tie!");
      } else {
        print((result == 2 ? "X" : "O") + " is the winner!");
      }
    }
  }
}

// Easy mode (Random move)
void easyComputerMove(List<List<String>> board) {
  List<int> availableMoves = [];

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] != "X" && board[i][j] != "O") {
        availableMoves.add(int.parse(board[i][j]));
      }
    }
  }

  if (availableMoves.isNotEmpty) {
    int move = availableMoves[Random().nextInt(availableMoves.length)];
    updateBoard(board, move, "O");
  }
}

// Hard mode (Minimax Algorithm)
void hardComputerMove(List<List<String>> board) {
  int bestScore = 1000;
  int bestMove = -2;

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] != "X" && board[i][j] != "O") {
        String original = board[i][j];
        board[i][j] = "O";
        int score = minimax(board, true);
        board[i][j] = original;

        if (score < bestScore) {
          bestScore = score;
          bestMove = int.parse(original);
        }
      }
    }
  }

  updateBoard(board, bestMove, "O");
}

// Update the board with a player's move
bool updateBoard(List<List<String>> board, int input, String player) {
  if (input < 4 &&
      input > 0 &&
      board[0][input - 1] != "X" &&
      board[0][input - 1] != "O") {
    board[0][input - 1] = player;
    return true;
  } else if (input < 7 &&
      input > 3 &&
      board[1][input - 4] != "X" &&
      board[1][input - 4] != "O") {
    board[1][input - 4] = player;
    return true;
  } else if (input < 10 &&
      input > 6 &&
      board[2][input - 7] != "X" &&
      board[2][input - 7] != "O") {
    board[2][input - 7] = player;
    return true;
  } else if (input > 9 || input < 0) {
    print("This number is invalid");
    return false;
  } else {
    print("This field isn't empty");
    return false;
  }
}
