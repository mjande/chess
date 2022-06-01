require_relative '../library'

class WhitePawn < Piece
  WHITE_STARTING_POSITIONS = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]].freeze

  def to_s
    ' ♟ '.colorize(:light_white)
  end

  def possible_moves
    Array[
      valid_move?(@row - 1, @column, color),
      different_color?(@row - 1, @column - 1, color),
      different_color?(@row - 1, @column + 1, color),
      @row == 6 ? valid_move?(@row - 2, @column, color) : nil
    ].compact
  end
end

class BlackPawn < Piece
  BLACK_STARTING_POSITIONS = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]].freeze

  def to_s
    ' ♟ '.colorize(:black)
  end

  def possible_moves
    Array[
      valid_move?(@row + 1, @column, color),
      different_color?(@row + 1, @column - 1, color),
      different_color?(@row + 1, @column + 1, color),
      @row == 1 ? valid_move?(@row + 2, @column, color) : nil
    ].compact
  end
end