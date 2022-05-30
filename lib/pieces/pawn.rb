require_relative 'piece'

class WhitePawn < Piece
  WHITE_STARTING_POSITIONS = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]].freeze

  def to_s
    ' ♟ '.colorize(:light_white)
  end

  def possible_moves
    Array[
      valid_move?(@row - 1, @column, color) ? [@row - 1, @column] : nil,
      valid_move?(@row - 2, @column, color) && @row == 6 ? [@row - 2, @column] : nil,  
      different_color?(@row - 1, @column - 1, color) ? [@row - 1, @column - 1] : nil,
      different_color?(@row - 1, @column + 1, color) ? [@row - 1, @column + 1] : nil
    ].compact
  end
end

class BlackPawn < Piece
  BLACK_STARTING_POSITIONS = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]].freeze

  def to_s
    ' ♟ '.colorize(:black)
  end
end