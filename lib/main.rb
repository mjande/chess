# frozen_string_literal: true

require_relative 'library'

board = Board.new
king = King.new(7, 4, 'white', board)
bishop = Bishop.new(6, 4, 'black', board)
queen = Queen.new(7, 3, 'white', board)
board.instance_variable_set(:@pieces, [queen, bishop, king])
king.update_possible_moves
