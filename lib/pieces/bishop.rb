require_relative '../library'

class Bishop < Piece
  WHITE_STARTING_POSITIONS = [[7, 2], [7, 5]].freeze
  BLACK_STARTING_POSITIONS = [[0, 2], [0, 5]].freeze

  def to_s
    color == 'white' ? ' ♝ '.colorize(:light_white) : ' ♝ '.colorize(:black)
  end

  def possible_moves
    possible_moves = []
    check_up_right.each { |position| possible_moves << position }
    check_up_left.each { |position| possible_moves << position }
    check_down_right.each { |position| possible_moves << position }
    check_down_left.each { |position| possible_moves << position }
    possible_moves
  end

  private

  def check_up_right
    moves_up_right = []
    next_row = @row - 1
    next_column = @column + 1
    while next_row >= 0 && next_column <= 7
      moves_up_right << [next_row, next_column] if valid_move?(next_row, next_column, color)
      break unless @board.positions[next_row][next_column].nil?

      next_row -= 1
      next_column += 1
    end
    moves_up_right
  end

  def check_up_left
    moves_up_left = []
    next_row = @row - 1
    next_column = @column - 1
    while next_row >= 0 && next_column >= 0
      moves_up_left << [next_row, next_column] if valid_move?(next_row, next_column, color)
      break unless @board.positions[next_row][next_column].nil?

      next_row -= 1
      next_column -= 1
    end
    moves_up_left
  end

  def check_down_right
    moves_down_right = []
    next_row = @row + 1
    next_column = @column + 1
    while next_row <= 7 && next_column <= 7
      moves_down_right << [next_row, next_column] if valid_move?(next_row, next_column, color)
      break unless @board.positions[next_row][next_column].nil?

      next_row += 1
      next_column += 1
    end
    moves_down_right
  end

  def check_down_left
    moves_down_left = []
    next_row = @row + 1
    next_column = @column - 1
    while next_row <= 7 && next_column >= 0
      moves_down_left << [next_row, next_column] if valid_move?(next_row, next_column, color)
      break unless @board.positions[next_row][next_column].nil?

      next_row += 1
      next_column -= 1
    end
    moves_down_left
  end
end