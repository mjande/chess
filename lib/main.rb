require_relative 'board'
require_relative 'player'

board = Board.new
board.display
white = Player.new('white', board)
white.create_pieces
black = Player.new('black', board)
black.create_pieces
board.display
