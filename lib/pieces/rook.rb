# frozen_string_literal: true

require_relative '../library'

# The Rook class handles starting squares and possible moves of all rooks
class Rook < Piece
  STARTING_COORDINATES = { 'white' => [[7, 0], [7, 7]],
                           'black' => [[0, 0], [0, 7]] }.freeze

  def to_s
    color == 'white' ? ' ♜ '.colorize(:light_white) : ' ♜ '.colorize(:black)
  end

  def update_possible_moves
    current_square = board.square(row, column)
    axial_coordinates = current_square.axial_coordinates
    add_coordinates_from_directions(axial_coordinates)
  end
end
