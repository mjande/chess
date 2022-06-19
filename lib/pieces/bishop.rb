# frozen_string_literal: true

require_relative '../library'

# Bishop class handles deciding the starting positions and possible moves for
# both sets of bishop pieces
class Bishop < Piece
  STARTING_POSITIONS = { 'white' => [[7, 2], [7, 5]],
                         'black' => [[0, 2], [0, 5]] }.freeze

  def to_s
    color == 'white' ? ' ♝ '.colorize(:light_white) : ' ♝ '.colorize(:black)
  end

  def update_possible_moves
    check_direction(-1, 1).each { |position| possible_moves << position }
    check_direction(-1, -1).each { |position| possible_moves << position }
    check_direction(1, 1).each { |position| possible_moves << position }
    check_direction(1, -1).each { |position| possible_moves << position }
  end

  def territory
    (row + column).even? ? 'light_squares' : 'dark_squares'
  end
end
