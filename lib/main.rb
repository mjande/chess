# frozen_string_literal: true

require_relative 'library'

board = Board.new
bishop = Bishop.new(7, 2, 'white', board)
white_king = King.new(7, 4, 'white', board)
black_king = King.new(0, 4, 'black', board)
rook = Rook.new(7, 0, 'black', board)
board.instance_variable_set(:@pieces, [bishop, white_king, black_king, rook])
board.update_all_possible_moves
