require_relative '../library'

class Bishop < Piece
  WHITE_STARTING_POSITIONS = [[7, 2], [7, 5]].freeze
  BLACK_STARTING_POSITIONS = [[0, 2], [0, 5]].freeze

  def to_s
    color == 'white' ? ' ♝ '.colorize(:light_white) : ' ♝ '.colorize(:black)
  end

  def possible_moves
    possible_moves = []
    check_diagonal(-1, 1).each { |position| possible_moves << position }
    check_diagonal(-1, -1).each { |position| possible_moves << position }
    check_diagonal(1, 1).each { |position| possible_moves << position }
    check_diagonal(1, -1).each { |position| possible_moves << position }
    possible_moves
  end

  private

  def check_diagonal(row_shift, column_shift)
    diagonal_moves = []
    next_row = @row + row_shift
    next_column = @column + column_shift
    while next_row.between?(0, 7) && next_column.between?(0, 7)
      diagonal_moves << valid_move?(next_row, next_column, color)
      break unless @board.positions[next_row][next_column].nil?

      next_row += row_shift
      next_column += column_shift
    end
    diagonal_moves.compact
  end
end

board = Board.new
c_bishop = Bishop.new(7, 2, 'white', board)
c_bishop.possible_moves
