require_relative '../library'

class King < Piece
  WHITE_STARTING_POSITIONS = [[7, 4]].freeze
  BLACK_STARTING_POSITIONS = [[0, 4]].freeze
  SYMBOL = ' ♚ '.freeze

  def to_s
    color == 'white' ? ' ♚ '.colorize(:light_white) : ' ♚ '.colorize(:black)
  end

  def update_possible_moves
    @possible_moves = Array[
      valid_move?(@row - 1, @column, color),
      valid_move?(@row - 1, @column + 1, color),
      valid_move?(@row, @column + 1, color),
      valid_move?(@row + 1, @column + 1, color),
      valid_move?(@row + 1, @column, color),
      valid_move?(@row + 1, @column - 1, color),
      valid_move?(@row, @column - 1, color),
      valid_move?(@row - 1, @column - 1, color)
    ].compact
  end

  def check?(check_row = @row, check_column = @column)
    pieces = (color == 'white' ? board.black_pieces : board.white_pieces)
    pieces.any? do |piece|
      piece.possible_moves.include?([check_row, check_column])
    end
  end

  def checkmate?
    possible_moves.all? do |position|
      check?(position[0], position[1])
    end
  end

  private

  def valid_move?(row, column, color)
    if on_the_board?(row, column) &&
       (@board.positions[row][column].nil? || different_color?(row, column, color)) &&
       !check?(row, column)
      [row, column]
    end
  end
end
