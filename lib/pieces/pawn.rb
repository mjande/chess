require_relative '../library'

class WhitePawn < Piece
  WHITE_STARTING_POSITIONS = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]].freeze

  def to_s
    ' ♟ '.colorize(:light_white)
  end

  def update_possible_moves
    @possible_moves = Array[
      empty_position?(@row - 1, @column),
      different_color?(@row - 1, @column - 1, color),
      different_color?(@row - 1, @column + 1, color),
      @row == 6 ? empty_position?(@row - 2, @column) : nil,
      en_passant?(column - 1),
      en_passant?(column + 1)
    ].compact
  end

  def en_passant_capture(new_column)
    move(2, new_column)
    capture(3, new_column)
  end

  private

  def en_passant?(new_column)
    passed_pawn = board.positions[3][new_column]
    return unless passed_pawn.instance_of?(BlackPawn)

    [2, new_column] if passed_pawn.previous_moves == [[1, new_column]]
  end
end

class BlackPawn < Piece
  BLACK_STARTING_POSITIONS = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]].freeze

  def to_s
    ' ♟ '.colorize(:black)
  end

  def update_possible_moves
    @possible_moves = Array[
      valid_move?(@row + 1, @column, color),
      different_color?(@row + 1, @column - 1, color),
      different_color?(@row + 1, @column + 1, color),
      @row == 1 ? valid_move?(@row + 2, @column, color) : nil,
      en_passant?(column - 1),
      en_passant?(column + 1)
    ].compact
  end

  def en_passant_capture(new_column)
    move(5, new_column)
    capture(4, new_column)
  end

  private

  def en_passant?(new_column)
    passed_pawn = board.positions[4][new_column]
    return unless passed_pawn.instance_of?(WhitePawn)

    [5, new_column] if passed_pawn.previous_moves == [[6, new_column]]
  end
end
