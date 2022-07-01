# frozen_string_literal: true

# The Queen class handles starting squares and possible moves of both queens
class Queen < Piece
  STARTING_COORDINATES = { 'white' => [[7, 3]],
                           'black' => [[0, 3]] }.freeze

  def to_s
    color == 'white' ? ' ♛ '.colorize(:light_white) : ' ♛ '.colorize(:black)
  end

  def update_possible_moves
    current_square = board.square(row, column)
    diagonal_coordinates = current_square.diagonal_coordinates
    add_coordinates_from_directions(diagonal_coordinates)
    axial_coordinates = current_square.axial_coordinates
    add_coordinates_from_directions(axial_coordinates)
  end
end
