# frozen_string_literal: true

# The Knight class handles starting squares and possible moves of both bishops
class Knight < Piece
  STARTING_COORDINATES = { 'white' => [[7, 1], [7, 6]],
                           'black' => [[0, 1], [0, 6]] }.freeze

  def to_s
    color == 'white' ? ' ♞ '.colorize(:light_white) : ' ♞ '.colorize(:black)
  end

  def update_possible_moves
    valid_coordinates =
      knight_square_coordinates.select do |square_coordinates|
        square = board.square(square_coordinates[0], square_coordinates[1])
        valid_move?(square)
      end
    valid_coordinates.each { |coordinates| possible_moves << coordinates }
  end

  def knight_square_coordinates
    knight_square_coordinates = []
    diffs = [1, 2, -1, -2]

    diffs.permutation(2) do |coordinate_diff|
      next if coordinate_diff[0].abs == coordinate_diff[1].abs

      coordinate =
        [row + coordinate_diff[0], column + coordinate_diff[1]]
      knight_square_coordinates << coordinate
    end
    knight_square_coordinates.uniq
  end
end
