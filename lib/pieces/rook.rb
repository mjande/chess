require_relative '../library'

class Rook < Piece
  WHITE_STARTING_POSITIONS = [[7, 0], [7, 7]].freeze
  BLACK_STARTING_POSITIONS = [[0, 0], [0, 7]].freeze

  def to_s
    color == 'white' ? ' ♜ '.colorize(:light_white) : ' ♜ '.colorize(:black)
  end

  def update_possible_moves
    check_direction(-1, 0).each { |position| possible_moves << position }
    check_direction(0, 1).each { |position| possible_moves << position }
    check_direction(1, 0).each { |position| possible_moves << position }
    check_direction(0, -1).each { |position| possible_moves << position }
  end
end
