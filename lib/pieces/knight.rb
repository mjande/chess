class Knight < Piece
  WHITE_STARTING_POSITIONS = [[7, 1], [7, 6]].freeze
  BLACK_STARTING_POSITIONS = [[0, 1], [0, 6]].freeze

  def to_s
    color == 'white' ? ' ♞ '.colorize(:light_white) : ' ♞ '.colorize(:black)
  end

  def possible_moves
    Array[
      valid_move?(@row + 2, @column + 1, color),
      valid_move?(@row + 2, @column - 1, color),
      valid_move?(@row + 1, @column + 2, color),
      valid_move?(@row - 1, @column + 2, color),
      valid_move?(@row - 2, @column + 1, color),
      valid_move?(@row - 2, @column - 1, color),
      valid_move?(@row - 1, @column - 2, color),
      valid_move?(@row + 1, @column - 2, color)
    ].compact
  end
end