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
-Create Input class and subclasses
-Create ability to save
-Create detailed README
