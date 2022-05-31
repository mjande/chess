require_relative 'library

board = Board.new
board.display
white = Player.new('white', board)
white.add_pieces_to_board
black = Player.new('black', board)
black.add_pieces_to_board
board.display
