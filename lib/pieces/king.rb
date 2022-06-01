require_relative '../library'

class King < Piece
  WHITE_STARTING_POSITIONS = [[7, 4]].freeze
  BLACK_STARTING_POSITIONS = [[0, 4]].freeze
  SYMBOL = ' ♚ '.freeze

  def to_s 
    color == 'white' ? ' ♚ '.colorize(:light_white) : ' ♚ '.colorize(:black)
  end

  def possible_moves
    Array[
      valid_move?(@row - 1, @column, color), 
      valid_move?(@row - 1, @column + 1, color),
      valid_move?(@row, @column + 1, color),
      valid_move?(@row + 1, @column + 1, color),
      valid_move?(@row + 1, @column, color),
      valid_move?(@row + 1, @column - 1, color),
      valid_move?(@row, @column - 1, color),
      valid_move?(@row - 1, @column - 1, color)
    ].compact
  # Check for check logic might go here at some point, but right now it makes sense to include in game class or somewhere with wider scope. 
  end
end
