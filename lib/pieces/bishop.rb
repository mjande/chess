# frozen_string_literal: true

require_relative '../library'

# The Bishop class handles starting squares and possible moves of both bishops
class Bishop < Piece
  STARTING_COORDINATES = { 'white' => [[7, 2], [7, 5]],
                           'black' => [[0, 2], [0, 5]] }.freeze

  def to_s
    color == 'white' ? ' ♝ '.colorize(:light_white) : ' ♝ '.colorize(:black)
  end

  def update_possible_moves
    coordinates = board.square(row, column).diagonal_coordinates
    add_coordinates_from_directions(coordinates)
  end
end
