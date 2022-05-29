require_relative 'board'
require_relative 'player'
require_relative 'pieces'

def start_game
  board = Board.new
  player1 = Player.new('white', board)
  player2 = Player.new('black', board)
end

def play_game
=begin
  Player 1 inputs their move
    Figure out which piece to move
    Update the board
    Check for checkmate 
  Player 2 inputs their move 
    Similar script
=end


end

def end_game
end

