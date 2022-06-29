# frozen_string_literal: true

require_relative 'library'

board = Board.new
center_king = King.new(board.square(4, 3), 'white', board)
# edge_king = King.new(board.square(7, 4), 'white', board)
board.instance_variable_set(:@pieces, [center_king])
center_king.update_possible_moves