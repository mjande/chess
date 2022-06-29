# frozen_string_literal: true

require_relative 'library'

board = Board.new

white_pawn = Pawn.new(3, 0, 'white', board)

black_pawn = Pawn.new(3, 1, 'black', board)
king = King.new(7, 4, 'white', board)
board.instance_variable_set(:@pieces, [white_pawn, black_pawn, king])
black_pawn.instance_variable_set(:@open_to_en_passant, true)
white_pawn.update_possible_moves
