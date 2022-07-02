# chess

## Development Log

### Dev Log #1

Board Class

-method to create array that stores all board positions
-method to populate the board with the starting pieces for both players
-method to display the current state of the board (as stored in array)

### Dev Log #2

Player Class

-Ask player for next move

### Dev Log #3

Hit a major road block after finishing the move validation method for Player. Issue was I couldn't figure how to send messages for moving pieces. Theoretically, player would have to send message to piece to see if it could move to the given coordinates, and then piece would tell board to update itself with its new position. This was impossible, because pieces had no way to access the board to send messages. So I moved around the structure, so now game is the super class that creates board, and then Game feeds the board to the players, who then feed it to the relevant pieces. So now the pieces can send an update all the way up the chain to the board. Then, I moved around the set_up methods to match, and now have a working starting board. My next move is to update the tests to match, and then begin working on giving each piece their potential moves (and possibly some refactoring of spaghetti code in there as well). 

Current problem: I'm really close to getting a working solution (despite my stupid choice to not TDD very often), but the current issue is that I am trying not let my pieces know too much, but the kings need to know what is going with the opposing pieces so they can check for check. And letting basically any class know the other player's pieces is too much information for literally every class except King. So I need to figure out how to either 1) selectively feed that info to King or 2) decide where the check? and checkmate? methods should go that should be allowed to know the other players pieces (maybe the Game class)???

First Working Version
To Do List
-Revisit tests
-Refactor like crazy
-Stalemate
-Create ability to save
-Create detailed README

Note: Refactoring to include Square class is basically finished, but I need to
test drive the basic game function and the tests to make sure it is working as
intended. After that, I need to add better test coverage, then refactor the
tests (before doing this, I'll need to figure out how to add RSpec linting to
Rubocop). Once all of that is done, I will look up some famous games and run them
through the program to catch any bugs, then I should be done.

Idea: remove board dependency from pieces. Use Square class method to deliver
squares to pieces, board remains dependent on pieces (less likely to change),
but pieces are no long depenedent on the board (also simplifies data structures alot,
removes need to board to contain pieces to contain board...).

Issue: In #leads_to_check?, I create a board clone to process whether a move would lead to check. Issue is that check is calculated based on pieces possible moves, so those possible moves need to be updated to calculate correctly. However, this results in an infinite loop where board calls
update_all_possible_moves, which sends #leads_to_check? to all pieces, which then sends update all possible moves to the board clone. Idea for a fix is to make update_all_possible_moves more selective so it ignores certain pieces?

To Do List
-Remove board dependencies from pieces (connect to specific square using class method Square.at() instead)
-Reflect on test coverage
-Refactor tests to reflect new linting

Board positions checklist
Capture
En_passant
Castling
Promotion
Check
Checkmate
Draw Conditions
  -No possible moves
  -Dead position
  -Mutual Agreement
  -threefold repetition
  -50 moves since capture
Save/Load

