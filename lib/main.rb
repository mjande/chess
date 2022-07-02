# frozen_string_literal: true

require_relative 'library'

board = Board.new
board.add_starting_pieces
puts board.display
