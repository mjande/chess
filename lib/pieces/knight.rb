# frozen_string_literal: true

# The Bishop class handles starting positions and possible moves of both bishops
class Knight < Piece
  STARTING_POSITIONS = { 'white' => [[7, 1], [7, 6]],
                         'black' => [[0, 1], [0, 6]] }.freeze

  def to_s
    color == 'white' ? ' ♞ '.colorize(:light_white) : ' ♞ '.colorize(:black)
  end

  def update_possible_moves
    @possible_moves = check_knight_squares.compact
  end

  def knight_squares
    knight_squares = []
    diffs = [1, 2, -1, -2]

    diffs.permutation(2) do |coordinate_diff|
      next if coordinate_diff[0].abs == coordinate_diff[1].abs

      coordinate = [row + coordinate_diff[0], column + coordinate_diff[1]]
      knight_squares << coordinate
    end
    knight_squares.uniq
  end

  def check_knight_squares
    knight_squares.select do |square|
      valid_move?(square[0], square[1], color)
    end
  end
end
