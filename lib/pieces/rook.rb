require_relative '../library'

class Rook < Piece
  WHITE_STARTING_POSITIONS = [[7, 0], [7, 7]].freeze
  BLACK_STARTING_POSITIONS = [[0, 0], [0, 7]].freeze

  def to_s
    color == 'white' ? ' ♜ '.colorize(:light_white) : ' ♜ '.colorize(:black)
  end

  def possible_moves
    possible_moves = []
    check_up.each { |position| possible_moves << position }
    check_right.each { |position| possible_moves << position }
    check_down.each { |position| possible_moves << position }
    check_left.each { |position| possible_moves << position }
    possible_moves
  end

  private

  def check_up
    moves_up = []
    next_row = @row - 1
    while next_row >= 0
      moves_up << [next_row, @column] if valid_move?(next_row, @column, color)
      break unless @board.positions[next_row][@column].nil?

      next_row -= 1
    end
    moves_up
  end

  def check_right
    moves_right = []
    next_column = @column + 1
    while next_column <= 7
      moves_right << [@row, next_column] if valid_move?(@row, next_column, color)
      break unless @board.positions[@row][next_column].nil?

      next_column += 1
    end
    moves_right
  end

  def check_down
    moves_down = []
    next_row = @row + 1
    while next_row <= 7
      moves_down << [next_row, @column] if valid_move?(next_row, @column, color)
      break unless @board.positions[next_row][@column].nil?

      next_row += 1
    end
    moves_down
  end

  def check_left
    moves_left = []
    next_column = @column - 1
    while next_column >= 0
      moves_left << [@row, next_column] if valid_move?(@row, next_column, color)
      break unless @board.positions[@row][next_column].nil?

      next_column -= 1
    end
    moves_left
  end
end