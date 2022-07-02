# frozen_string_literal: true

# The Knight class handles starting squares and possible moves of both bishops
class Knight < Piece
  STARTING_COORDINATES = { 'white' => [[7, 1], [7, 6]],
                           'black' => [[0, 1], [0, 6]] }.freeze

  def to_s
    color == 'white' ? ' ♞ '.colorize(:light_white) : ' ♞ '.colorize(:black)
  end

  # This method uses #knight_coordinates to find all possible squares relevant
  # to knight movement, then checks to see if they are unoccupied or open to
  # capture.
  def update_possible_moves
    current_square = board.square(row, column)
    valid_coordinates =
      current_square.knight_coordinates.select do |square_coordinates|
        square = board.square(square_coordinates[0], square_coordinates[1])
        valid_move?(square)
      end
    valid_coordinates.each { |coordinates| possible_moves << coordinates }
  end
end
