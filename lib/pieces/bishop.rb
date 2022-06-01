require_relative '../library'

class Bishop < Piece
  WHITE_STARTING_POSITIONS = [[7, 2], [7, 5]].freeze
  BLACK_STARTING_POSITIONS = [[0, 2], [0, 5]].freeze

  def to_s
    color == 'white' ? ' ♝ '.colorize(:light_white) : ' ♝ '.colorize(:black)
  end

  def possible_moves
    possible_moves = []
    check_direction(-1, 1).each { |position| possible_moves << position }
    check_direction(-1, -1).each { |position| possible_moves << position }
    check_direction(1, 1).each { |position| possible_moves << position }
    check_direction(1, -1).each { |position| possible_moves << position }
    possible_moves
  end
end
