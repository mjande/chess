# frozen_string_literal: true

require_relative '../library'

# The Bishop class handles starting squares and possible moves of both bishops
class Bishop < Piece
  STARTING_SQUARES = { 'white' => [board.square(7, 2), board.square(7, 5)],
                       'black' => [board.square(0, 2), board.square(0,)] }.freeze

  def to_s
    color == 'white' ? ' ♝ '.colorize(:light_white) : ' ♝ '.colorize(:black)
  end

  def update_possible_moves
    check_diagonals
  end
end
